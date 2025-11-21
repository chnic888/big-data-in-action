#!/bin/bash

INSTANCES_TO_PURGE=$(multipass list | awk '/^vm/ {print $1}')

if [ -n "$INSTANCES_TO_PURGE" ]; then
        INSTANCES_TO_PURGE=$(multipass list | awk '/^vm/ {print $1}' | tr '\n' ' ')
    
    if [ -n "$INSTANCES_TO_PURGE" ]; then
        echo "Stopping and deleting the following instances: $INSTANCES_TO_PURGE"
        multipass delete $INSTANCES_TO_PURGE
    else
        echo "No instances starting with 'vm' found."
    fi
    multipass delete $INSTANCES_TO_PURGE
else
    echo "No instances starting with 'vm' found."
fi

multipass list