#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <instance number> <>"
    exit 1
fi

start_index=10
count=$1

for ((i = 1; i <= count; i++));
do
    instance="vmw0$i"
    echo "Launch VM instance $instance."
    multipass launch jammy --name $instance -c 4 -m 4G -d 10G --network name=localbr,mode=manual

    mac_address=$(multipass exec $instance -- ip address | awk '/^[0-9]+:/ { current=$2; gsub(/:/,"",current); } /^[[:space:]]*link/ { mac=$2; } END { print mac }')
    sub_index=$((start_index + i))

    echo "Create /etc/netplan/10-custom.yaml for $instance."
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

    echo "Apply netplan for $instance."
    multipass exec -n $instance -- sudo netplan apply >> /dev/null 2>&1

    echo "Launch VM instance $instance successfully."
done