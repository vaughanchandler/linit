#!/bin/bash

# Pushes all the changes after finishing a release with gitflow.

git push origin --tags && git checkout develop && git push && git checkout master && git push
exit $?
