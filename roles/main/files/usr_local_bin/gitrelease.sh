#!/bin/bash

# Pushes all the changes after finishing a release with gitflow.
# By Vaughan Chandler

git push origin --tags && git checkout develop && git push && git checkout master && git push
exit $?
