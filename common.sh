#!/bin/bash

DPDK_DIR="${NFF_GO}"/dpdk/dpdk-${DPDK_VERSION}

bindports ()
{
    if ! lsmod | grep -q igb_uio; then
        sudo modprobe uio
        sudo insmod ${DPDK_DIR}/x86_64-native-linuxapp-gcc/kmod/igb_uio.ko
    fi
    sudo ${DPDK_DIR}/usertools/dpdk-devbind.py --bind=igb_uio ${@}
}

unbindports ()
{
    sudo ${DPDK_DIR}/usertools/dpdk-devbind.py --bind=${LINUX_DRIVER} ${@}
}

disconnect_interfaces()
{
    sudo nmcli d disconnect ${@}
}

setup_interface()
{
    while sudo nmcli c del $1-nff-go
    do
        true
    done
    sudo nmcli c add type ethernet ifname $1 con-name $1-nff-go ip4 $2
    sudo nmcli d connect $1
    sudo nmcli c up $1-nff-go
}

establish_forwarding()
{
    if ! sudo iptables -t nat -C POSTROUTING -o $1 -j MASQUERADE
    then
        sudo iptables -t nat -A POSTROUTING -o $1 -j MASQUERADE
    fi
    if ! sudo iptables -C FORWARD -i $1 -o $0 -m state --state RELATED,ESTABLISHED -j ACCEPT
    then
        sudo iptables -A FORWARD -i $1 -o $0 -m state --state RELATED,ESTABLISHED -j ACCEPT
    fi
    if ! sudo iptables -C FORWARD -i $0 -o $1 -j ACCEPT
    then
        sudo iptables -A FORWARD -i $0 -o $1 -j ACCEPT
    fi
}

# Configure DPDK interfaces
if [ ! -z ${DPDK_CARD_NAMES[*]} ]
then
    disconnect_interfaces ${DPDK_CARD_NAMES[*]}
    bindports ${DPDK_CARD_IDS[*]}
fi

# Configure linux interfaces
if [ ! -z ${LINUX_CARD_IDS[*]} ]
then
    unbindports ${LINUX_CARD_IDS[*]}
    for (( i=0; i<${#LINUX_CARD_NAMES[*]}; i++ ))
    do
        setup_interface ${LINUX_CARD_NAMES[$i]} ${LINUX_NETMASKS[$i]}
    done
    for (( i=0; i<${#LINUX_ROUTE_NETWORKS[*]}; i++ ))
    do
        setup_route ${LINUX_ROUTE_NETWORKS[$i]} ${LINUX_ROUTE_VIA[$i]}
    done
fi
if [ ! -z ${LINUX_FIREWALL} ] && (( ${#LINUX_CARD_NAMES[*]} == 2 ))
then
    establish_forwarding ${LINUX_CARD_NAMES[0]} ${LINUX_CARD_NAMES[1]}
fi
