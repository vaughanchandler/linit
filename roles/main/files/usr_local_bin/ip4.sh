#!/bin/bash

# Resolves specified hostnames via DNS, or shows the local IPs if no hostnames were specified.
# By Vaughan Chandler
# Usage: ./ip4.sh [hostname...]

output=
if [[ -n "$@" ]]; then
    for host in $@; do
        if command -v systemctl &>/dev/null && systemctl is-active systemd-resolved &>/dev/null; then
            if command -v resolvectl &>/dev/null; then
                resolvectl query -t A "$host"
            else
                systemd-resolve -t A "$host"
            fi
        elif command -v host &>/dev/null; then
            host -t A "$host"
        elif command -v ping &>/dev/null; then
            ping -4nc1 "$host"
        else
            echo 'No supported command found for performing DNS lookup.'
            exit 1
        fi
    done
else
    if command -v ip &> /dev/null; then
        gw=$(ip r | grep default | grep -Po ' dev \K(\S+)' | sort -u | paste -sd '|')
        ip -4 -br -c a | awk '
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
            / inet / && !/ 127\.0\.0\.1 / {print i" "$2" "$4" "d}
        ' | column -t
    fi
fi
