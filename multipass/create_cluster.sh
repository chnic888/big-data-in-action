#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <instance number>"
    exit 1
fi

current_dir=$(dirname "$0")
start_index=10
count=$1

cat ~/.ssh/id_rsa.pub >> "$current_dir/1.tmp"

for ((i = 1; i <= count; i++));
do
    instance="vm0$i"
    if multipass list | grep -q $instance; then
      continue
    fi

    echo "Launch VM instance $instance."
    multipass launch jammy --name $instance -c 4 -m 4G -d 10G --network name=localbr,mode=manual

    mac_address=$(multipass exec $instance -- ip address | awk '/^[0-9]+:/ { current=$2; gsub(/:/,"",current); } /^[[:space:]]*link/ { mac=$2; } END { print mac }')
    sub_index=$((start_index + i))

    multipass exec -n $instance -- sudo bash -c "cat << EOF > /etc/netplan/10-custom.yaml
network:
    version: 2
    ethernets:
        extra0:
            dhcp4: no
            match:
                macaddress: \"$mac_address\"
            addresses: [10.13.31.$sub_index/24]
EOF"

    multipass exec -n $instance -- sudo netplan apply >> /dev/null 2>&1
    multipass transfer ./1.tmp $instance:/tmp/id_rsa.pub
    multipass exec $instance -- bash -c 'mkdir -p ~/.ssh && cat /tmp/id_rsa.pub >> ~/.ssh/authorized_keys && rm /tmp/id_rsa.pub'

    echo "10.13.31.$sub_index" >> "$current_dir/inventory"
    echo "Launch VM instance $instance successfully."
done

rm "$current_dir/1.tmp"