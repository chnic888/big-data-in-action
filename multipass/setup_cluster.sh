#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <instance number>"
    exit 1
fi

current_dir=$(dirname "$0")
node_count=$1

echo "copy id_rsa.pub..."
cat ~/.ssh/id_rsa.pub > "$current_dir/1.tmp"

for ((i = 1; i <= node_count; i++));
do
    instance="vm$i"

    if [ ${#i} -eq 1 ]; then
      instance="vm0$i"
    fi

    if multipass list | grep -q $instance; then
      continue
    fi

    echo "Launch VM instance $instance..."
    multipass launch jammy --name $instance -c 1 -m 2G -d 5G

    echo "Copy id_rsa.pub to $instance..."
    multipass transfer ./1.tmp $instance:/tmp/id_rsa.pub
    multipass exec $instance -- bash -c 'mkdir -p ~/.ssh && cat /tmp/id_rsa.pub >> ~/.ssh/authorized_keys && rm /tmp/id_rsa.pub'

    ip=$(multipass exec $instance -- bash -c "hostname -I | cut -d ' ' -f 1")
    echo "Write IP ${ip} to inventory file..."
    echo "${ip}" >> "$current_dir/inventory"

    echo "Launch VM instance $instance successfully..."
done

rm "$current_dir/1.tmp"