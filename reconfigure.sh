#!/bin/bash

check_env()
{
    if [[ $EUID -ne 0 ]]; then
        echo "This script must be run as root. Use sudo -E reconfigre.sh to run it."
        exit 1
    fi
    if [ -z "${NFF_GO}" ]
    then
        echo "You need to define NFF_GO variable which points to root of built NFF_GO repository."
        exit 1
    fi
    if [ -z "${DPDK_VERSION}" ]
    then
        echo "You need to define DPDK_VERSION variable with DPDK version that should be used to find DPDK modules and scripts."
        exit 1
    fi
}

bindports ()
{
    echo BINDING CARDS ${@}
    if ! lsmod | grep -q igb_uio; then
        modprobe uio
        insmod "${DPDK_DIR}"/x86_64-native-linuxapp-gcc/kmod/igb_uio.ko
    fi
    "${DPDK_DIR}"/usertools/dpdk-devbind.py --bind=igb_uio ${@}
}

unbindports ()
{
    echo UNBINDING CARDS ${@}
    "${DPDK_DIR}"/usertools/dpdk-devbind.py --bind="${LINUX_DRIVER}" ${@}
}

disconnect_interfaces()
{
    echo DISCONNECTING CARDS ${@}
    nmcli d disconnect ${@}
    for int in ${@}
    do
        wipe_configs $(nmcli c s | grep $int | cut -d" " -s -f1)
    done
}

clean_trash()
{
    i=1
    while nmcli c del "Wired connection ${i}" &> /dev/null
    do
        echo DELETED NETWORK CONFIGURATION "Wired connection ${i}"
        i=$((i+1))
    done
}

wipe_configs()
{
    for config in "${@}"
    do
        while nmcli c del "$config" &> /dev/null
        do
            echo DELETED NETWORK CONFIGURATION "$config"
        done
    done
}

add_network_config()
{
    if [ -z "$3" ]
    then
        echo ADDING ETHERNET CONFIG FOR $1 WITH NETMASK $2
        wipe_configs $1 $1-nff-go
        nmcli c add type ethernet ifname $1 con-name $1-nff-go ip4 $2
    else
        echo ADDING VLAN CONFIG FOR $1 WITH NETMASK $2 AND ID $3
        wipe_configs $1-nff-go.$3
        nmcli c add type vlan dev $1 con-name $1-nff-go.$3 ip4 $2 id $3 mtu 1496
    fi
}

bring_up_interface()
{
    if [ -z "$2" ]
    then
        name=$1-nff-go
    else
        name=$1-nff-go.$2
    fi
    echo BRINGING UP INTERFACE $name
    nmcli c up $name
}

setup_route()
{
    if [ -z "$4" ]
    then
        dev=$3
    else
        dev=$3.$4
    fi
    echo SETTING UP ROUTE TO $1 VIA $2 USING $dev
    ip route add $1 via $2 dev $dev
}

establish_forwarding()
{
    echo SETTING UP FORWARDING FROM $1 TO $2
    sysctl -w net.ipv4.ip_forward=1
    if ! iptables -t nat -C POSTROUTING -o $2 -j MASQUERADE
    then
        iptables -t nat -A POSTROUTING -o $2 -j MASQUERADE
    fi
    if ! iptables -C FORWARD -i $2 -o $1 -m state --state RELATED,ESTABLISHED -j ACCEPT
    then
        iptables -A FORWARD -i $2 -o $1 -m state --state RELATED,ESTABLISHED -j ACCEPT
    fi
    if ! iptables -C FORWARD -i $1 -o $2 -j ACCEPT
    then
        iptables -A FORWARD -i $1 -o $2 -j ACCEPT
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
if [ ! -z "${LINUX_CARD_IDS[*]}" ] && [ ! -z "${#LINUX_CARD_NAMES[*]}" ] && [ ! -z "${LINUX_DRIVER}" ]
then
    clean_trash
    for (( i=0; i<${#LINUX_CARD_NAMES[*]}; i++ ))
    do
        if [ ! -z "${LINUX_NETMASKS[$i]}" ]
        then
            add_network_config ${LINUX_CARD_NAMES[$i]} ${LINUX_NETMASKS[$i]} ${LINUX_VLANS[$i]}
        fi
        unbindports ${LINUX_CARD_IDS[$i]}
        if [ ! -z "${LINUX_NETMASKS[$i]}" ]
        then
            bring_up_interface ${LINUX_CARD_NAMES[$i]} ${LINUX_VLANS[$i]}
        fi
    done
    clean_trash
    if [ ! -z "${LINUX_ROUTE_NETWORKS[*]}" ] && [ ! -z "${LINUX_ROUTE_VIA[*]}" ]
    then
        for (( i=0; i<${#LINUX_ROUTE_NETWORKS[*]}; i++ ))
        do
            if [ ! -z ${LINUX_ROUTE_NETWORKS[$i]} ] && [ ! -z ${LINUX_ROUTE_VIA[$i]} ]
            then
                setup_route ${LINUX_ROUTE_NETWORKS[$i]} ${LINUX_ROUTE_VIA[$i]} ${LINUX_CARD_NAMES[$i]} ${LINUX_VLANS[$i]}
            fi
        done
    fi
fi
if [ ! -z "${LINUX_FIREWALL}" ]
then
    if  (( ${#LINUX_CARD_NAMES[*]} == 2 ))
    then
        if [ -z "${LINUX_VLANS[*]}" ]
        then
            establish_forwarding ${LINUX_CARD_NAMES[0]} ${LINUX_CARD_NAMES[1]}
        else
            establish_forwarding ${LINUX_CARD_NAMES[0]}.${LINUX_VLANS[0]} ${LINUX_CARD_NAMES[1]}.${LINUX_VLANS[1]}
        fi
    else
        echo LINUX_FIREWALL works only when LINUX_CARD_NAMES has two cards
    fi
fi
