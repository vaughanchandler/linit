#!/bin/bash

# Shows IPv4 details.
# By Vaughan Chandler
# 2021.02.24

if [ "$1" == "-h" ]; then
    echo
    echo "Resolves specified hostnames via DNS, or shows the local IPs if no hostnames were specified."
    echo
    echo "Usage:  $0 [options] [hostname...]"
    echo
    echo "Options (only one can specified):"
    echo "  -d  Only show the default IP addresses (in local IP mode)"
    echo "  -o  Only show the IP addresses"
    echo "  -v  Versbose output"
    echo
    echo "The hostname 'ext' is special, and shows your external IP address."
    echo
    exit 0
fi

function resolve {
    if command -v systemctl &>/dev/null && systemctl is-active systemd-resolved &>/dev/null; then
        if command -v resolvectl &>/dev/null; then
            [ "$mode" == "-v" ] && echo "Resolving $host using resolvectl"
            resolvectl query -t A "$host" 2>&1
        else
            [ "$mode" == "-v" ] && echo "Resolving $host using systemd-resolve"
            systemd-resolve -t A "$host" 2>&1
        fi
    elif command -v drill &>/dev/null; then
        [ "$mode" == "-v" ] && echo "Resolving $host using drill"
        drill -t A "$host" 2>&1
    elif command -v host &>/dev/null; then
        [ "$mode" == "-v" ] && echo "Resolving $host using host"
        host -t A "$host" 2>&1
    elif command -v ping &>/dev/null; then
        [ "$mode" == "-v" ] && echo "Resolving $host using ping"
        ping -4nc1 "$host" 2>&1
    else
        echo 'No supported command found for performing DNS lookup.' >&2
        exit 1
    fi
}

function interfaces {
    if command -v ip &> /dev/null; then
        gw=$(ip r | grep default | grep -Po ' dev \K(\S+)' | sort -u | paste -sd '|')
        ip -4 -br $ip_colour a | awk '
            d=""
            '"/($gw)/"' {d="default"}
            !/127\.0\.0\.1/ {print $0" "d}
        ' | column -t
    elif command -v ifconfig &> /dev/null; then
        gw=$(route -n | awk '$1 ~ /^0.0.0.0$/ && $2 !~ /^0.0.0.0$/ {print $NF}' | sort -u | paste -sd '|')
        ifconfig | awk '
            /^\S/ {
                d=""
                i=$1
                sub(":","",i)
            }
            '"/^($gw):/"' {d="default"}
            / inet / && !/ 127\.0\.0\.1 / {print i" "$4" "$2" "d}
        ' | column -t
    else
        echo 'No supported command found for querying interfaces.' >&2
        exit 1
    fi
}

ip_colour=""
mode=""
if [[ "$1" == "-d" ]] || [[ "$1" == "-o" ]] || [[ "$1" == "-v" ]]; then
    mode=$1
    shift
fi

if [[ "$@" == "ext" ]]; then
    # External IP
    ip=$(curl -4s icanhazip.com)
    echo $ip
    if [[ "$mode" == "-v" ]] && [[ -n "$ip" ]] && command -v whois &> /dev/null; then
        whois $ip | grep -Po 'Organization: *\K.*'
    fi
elif [[ -n "$@" ]]; then
    # DNS resolution
    for host in $@; do
        if [[ "$mode" == "-v" ]]; then
            resolve
            echo
        elif [[ "$mode" == "-o" ]]; then
            resolve | grep -Po "(\sIN\sA\s| has address |PING \S+ \()\K\d+\.\d+\.\d+\.\d+"
        else
            printf "%s " $host
            for ip in $(resolve | grep -Po "(\sIN\sA\s| has address |PING \S+ \()\K\d+\.\d+\.\d+\.\d+"); do
                printf "%s " $ip
            done
            echo
        fi
    done
else
    # Local IP
    if [[ "$mode" == "-v" ]]; then
        ip_colour="-c"
        interfaces
    elif [[ "$mode" == "-d" ]]; then
        interfaces | awk '$4 ~ /default/ {print $3}' | sed -r 's~/.*~~'
    elif [[ "$mode" == "-o" ]]; then
        interfaces | awk '{print $3}' | sed -r 's~/.*~~'
    else
        interfaces | awk '{print $3}'
    fi
fi
