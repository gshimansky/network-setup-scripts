#!/bin/bash

DPDK_CARD_IDS=(00:06.0 00:08.0)
DPDK_CARD_NAMES=(ens6 ens8)

LINUX_DRIVER=e1000
LINUX_CARD_IDS=(00:07.0 00:09.0)
LINUX_CARD_NAMES=(ens7 ens9)
LINUX_VLANS=(124 126)
LINUX_NETMASKS=(192.168.124.1/24 192.168.126.1/24)
LINUX_FIREWALL=1
LINUX_ROUTE_NETWORKS=
LINUX_ROUTE_VIA=
