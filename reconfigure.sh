#!/bin/bash

check_env()
{
    if [ -z "${NFF_GO}" ]
    then
        echo You need to define NFF_GO variable which points to root of built NFF_GO repository
        exit 1
    fi
}

bindports ()
{
    echo BINDING CARDS ${@}
    if ! lsmod | grep -q igb_uio; then
        sudo modprobe uio
        sudo insmod ${DPDK_DIR}/x86_64-native-linuxapp-gcc/kmod/igb_uio.ko
    fi
    sudo ${DPDK_DIR}/usertools/dpdk-devbind.py --bind=igb_uio ${@}
}

unbindports ()
{
    echo UNBINDING CARDS ${@}
    sudo ${DPDK_DIR}/usertools/dpdk-devbind.py --bind=${LINUX_DRIVER} ${@}
}

disconnect_interfaces()
{
    echo DISCONNECTING CARDS ${@}
    sudo nmcli d disconnect ${@}
    wipe_configs ${@}
}

clean_trash()
{
    i=1
    while sudo nmcli c del "Wired connection ${i}" &> /dev/null
    do
        echo Deleted network configuration "Wired connection ${i}"
        i=$((i+1))
    done
}

wipe_configs()
{
    for config in "${@}"
    do
        while sudo nmcli c del "$config" &> /dev/null
        do
            echo Deleted network configuration "$config"
        done
    done
}

add_network_config()
{
    echo ADDING CONFIG FOR $1 with netmask $2
    wipe_configs $1 $1-nff-go
    sudo nmcli c add type ethernet ifname $1 con-name $1-nff-go ip4 $2
}

bring_up_interface()
{
    echo BRINGING UP INTERFACE $1
    sudo nmcli c up $1-nff-go
}

setup_route()
{
    echo SETTING UP ROUTE TO $1 VIA $2 USING $3
    sudo ip route add $1 via $2 dev $3
}

establish_forwarding()
{
    echo SETTING UP FORWARDING FROM $1 TO $2
    if ! sudo iptables -t nat -C POSTROUTING -o $2 -j MASQUERADE
    then
        sudo iptables -t nat -A POSTROUTING -o $2 -j MASQUERADE
    fi
    if ! sudo iptables -C FORWARD -i $2 -o $1 -m state --state RELATED,ESTABLISHED -j ACCEPT
    then
        sudo iptables -A FORWARD -i $2 -o $1 -m state --state RELATED,ESTABLISHED -j ACCEPT
    fi
    if ! sudo iptables -C FORWARD -i $1 -o $2 -j ACCEPT
    then
        sudo iptables -A FORWARD -i $1 -o $2 -j ACCEPT
    fi
}

# Check arguments
check_env

if [ "$#" -ne 1 ]
then
    echo Usage: reconfigure.sh \<config file\>
    exit 2
fi

# Read config
if [ -f "$1" ]
then
   . "$1"
else
    echo Config file "$1" does not exist
    exit 3
fi

DPDK_DIR="${NFF_GO}/dpdk/dpdk-${DPDK_VERSION}"

# Configure DPDK interfaces
if [ ! -z "${DPDK_CARD_NAMES[*]}" ] && [ ! -z "${DPDK_CARD_IDS[*]}" ]
then
    disconnect_interfaces ${DPDK_CARD_NAMES[*]}
    bindports ${DPDK_CARD_IDS[*]}
    clean_trash
fi

# Configure linux interfaces
if [ ! -z "${LINUX_CARD_IDS[*]}" ] && [ ! -z "${#LINUX_CARD_NAMES[*]}" ] && [ ! -z "${LINUX_NETMASKS[$i]}" ]
then
    clean_trash
    for (( i=0; i<${#LINUX_CARD_NAMES[*]}; i++ ))
    do
        add_network_config ${LINUX_CARD_NAMES[$i]} ${LINUX_NETMASKS[$i]}
        unbindports ${LINUX_CARD_IDS[$i]}
        bring_up_interface ${LINUX_CARD_NAMES[$i]} ${LINUX_NETMASKS[$i]}
    done
    clean_trash
    if [ ! -z "${LINUX_ROUTE_NETWORKS[*]}" ] && [ ! -z "${LINUX_ROUTE_VIA[*]}" ]
    then
        for (( i=0; i<${#LINUX_ROUTE_NETWORKS[*]}; i++ ))
        do
            setup_route ${LINUX_ROUTE_NETWORKS[$i]} ${LINUX_ROUTE_VIA[$i]} ${LINUX_CARD_NAMES[$i]}
        done
    fi
fi
if [ ! -z "${LINUX_FIREWALL}" ] && (( ${#LINUX_CARD_NAMES[*]} == 2 ))
then
    establish_forwarding ${LINUX_CARD_NAMES[0]} ${LINUX_CARD_NAMES[1]}
fi
