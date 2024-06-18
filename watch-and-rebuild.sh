#!/bin/sh
# Find all files in the content, assets, and themes directories
# and watch for changes using entr.
find ./content ./assets ./themes | entr -r hugo --destination /output