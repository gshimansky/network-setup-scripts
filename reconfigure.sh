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
}

bindports ()
{
    MODULE_PATH="${DPDK_DIR}/x86_64-native-linuxapp-gcc-install/lib/modules/$(uname -r)/extra/dpdk"
    echo BINDING CARDS ${@}
    if ! lsmod | grep -q igb_uio; then
        modprobe uio
        insmod "${MODULE_PATH}"/igb_uio.ko
    fi
    if ! lsmod | grep -q rte_kni; then
        insmod "${MODULE_PATH}"/rte_kni.ko
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
    cardname=$1
    ipv4=$2
    ipv6=$3
    vlantag=$4
    route4=$5
    via4=$6
    route6=$7
    via6=$8

    if [ ! -z "${ipv4}" ]
    then
        IPv4_ADDR="ip4 ${ipv4}"
        MSG=" WITH NETMASK ${ipv4}"
    fi

    if [ ! -z "${ipv6}" ]
    then
        IPv6_ADDR="ip6 ${ipv6}"
        MSG="${MSG} WITH V6 NETMASK ${ipv6}"
    fi

    if [ -z "${vlantag}" ]
    then
        WIPE="${cardname} ${cardname}-nff-go"
        CONNAME="${cardname}-nff-go"
        TYPE="ethernet ifname ${cardname}"
    else
        WIPE="${cardname}-nff-go.${vlantag}"
        CONNAME="${cardname}-nff-go.${vlantag}"
        MSG="${MSG} AND ID ${vlantag}"
        TYPE="vlan dev ${cardname} id ${vlantag} mtu 1496"
    fi

    if [ ! -z "${route4}" ] && [ ! -z "${via4}" ]
    then
        ROUTE4="ipv4.routes \"${route4} ${via4}\""
    fi

    if [ ! -z "${route6}" ] && [ ! -z "${via6}" ]
    then
        ROUTE6="ipv6.routes \"${route6} ${via6}\""
    fi

    echo ADDING ETHERNET CONFIG FOR ${cardname} ${MSG}
    wipe_configs ${WIPE}
    eval nmcli c add type ${TYPE} con-name ${CONNAME} ${IPv4_ADDR} ${IPv6_ADDR} "${ROUTE4}" "${ROUTE6}"
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
    sysctl -w net.ipv6.conf.default.forwarding=1
    sysctl -w net.ipv6.conf.all.forwarding=1

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

    if ! ip6tables -t nat -C POSTROUTING -o $2 -j MASQUERADE
    then
        ip6tables -t nat -A POSTROUTING -o $2 -j MASQUERADE
    fi
    if ! ip6tables -C FORWARD -i $2 -o $1 -m state --state RELATED,ESTABLISHED -j ACCEPT
    then
        ip6tables -A FORWARD -i $2 -o $1 -m state --state RELATED,ESTABLISHED -j ACCEPT
    fi
    if ! ip6tables -C FORWARD -i $1 -o $2 -j ACCEPT
    then
        ip6tables -A FORWARD -i $1 -o $2 -j ACCEPT
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

DPDK_DIR="${NFF_GO}/dpdk/dpdk"

# Configure DPDK interfaces
if [ ! -z "${DPDK_CARD_NAMES[*]}" ] && [ ! -z "${DPDK_CARD_IDS[*]}" ]
then
    disconnect_interfaces ${DPDK_CARD_NAMES[*]}
    bindports ${DPDK_CARD_IDS[*]}
    clean_trash
fi

# Configure linux interfaces
if [ ! -z "${#LINUX_CARD_NAMES[*]}" ] && [ ! -z "${LINUX_DRIVER}" ]
then
    clean_trash
    for (( i=0; i<${#LINUX_CARD_NAMES[*]}; i++ ))
    do
        if [ ! -z "${LINUX_NETMASKS[$i]}" ]
        then
            add_network_config "${LINUX_CARD_NAMES[$i]}" "${LINUX_NETMASKS[$i]}" "${LINUX_NETMASKS_V6[$i]}" "${LINUX_VLANS[$i]}" "${LINUX_ROUTE_NETWORKS[$i]}" "${LINUX_ROUTE_VIA[$i]}" "${LINUX_ROUTE_NETWORKS_V6[$i]}" "${LINUX_ROUTE_VIA_V6[$i]}"
        fi
        if [ ! -z "${LINUX_CARD_IDS[$i]}" ]
        then
               unbindports ${LINUX_CARD_IDS[$i]}
        fi
        if [ ! -z "${LINUX_NETMASKS[$i]}" ]
        then
            bring_up_interface "${LINUX_CARD_NAMES[$i]}" "${LINUX_VLANS[$i]}"
        fi
    done
    clean_trash
fi

if [ ! -z "${LINUX_FIREWALL}" ]
then
    for (( i=0; i<${#LINUX_FIREWALL[*]}; i+=2 ))
    do
        establish_forwarding ${LINUX_FIREWALL[$i]} ${LINUX_FIREWALL[$i+1]}
    done
fi

sudo systemctl restart docker.service
