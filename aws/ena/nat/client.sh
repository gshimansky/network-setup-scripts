#!/bin/bash

DPDK_CARD_IDS=
DPDK_CARD_NAMES=

LINUX_DRIVER=ena
LINUX_CARD_IDS=(00:06.0 00:07.0)
LINUX_CARD_NAMES=(ens6 ens7)
LINUX_NETMASKS=(192.168.14.2/24 192.168.24.2/24)
LINUX_NETMASKS_V6=(fd14::2/64 fd24::2/64)
LINUX_FIREWALL=()
LINUX_ROUTE_NETWORKS=(192.168.16.0/24 192.168.26.0/24)
LINUX_ROUTE_NETWORKS_V6=(fd16::/64 fd26::/64)
LINUX_ROUTE_VIA=(192.168.14.1 192.168.24.1)
LINUX_ROUTE_VIA_V6=(fd14::1 fd24::1)
