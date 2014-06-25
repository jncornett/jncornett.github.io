#!/bin/bash

# Watches a file or a directory tree and triggers a specified command
# when a file within that directory changes

function print_usage()
{
    echo "Usage: trigger-onchange <directory-or-file-path> [<commands>...]"
}

if [ -z "$1" ]; then
    print_usage
    exit
fi

TRON_WATCHDIR="$1"
shift
TRON_CMDSTRING="$@"

echo "Trigger.OnChange: Start"

while true
do
    change=$(inotifywait -e close_write,moved_to,create $TRON_WATCHDIR)
    echo "change detected: ${change}"

    if [ -z "$change" ]
    then
        echo "inotify process terminated, exiting"
        echo "Trigger.OnChange: Stop"
        exit
    fi
    
    ("$@")
done

echo "Trigger.OnChange: Stop"
