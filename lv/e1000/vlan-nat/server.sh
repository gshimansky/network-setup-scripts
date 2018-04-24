#!/bin/bash

DPDK_VERSION=18.02
DPDK_CARD_IDS=
DPDK_CARD_NAMES=

LINUX_DRIVER=e1000
LINUX_CARD_IDS=(00:06.0 00:07.0)
LINUX_CARD_NAMES=(eth1 eth2)
LINUX_VLANS=(116 126)
LINUX_NETMASKS=(192.168.116.2/24 192.168.126.2/24)
LINUX_FIREWALL=
LINUX_ROUTE_NETWORKS=
LINUX_ROUTE_VIA=