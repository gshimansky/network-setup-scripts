#!/bin/bash

DPDK_CARD_IDS=
DPDK_CARD_NAMES=

LINUX_DRIVER=e1000
LINUX_CARD_IDS=(00:06.0 00:07.0)
LINUX_CARD_NAMES=(ens6 ens7)
LINUX_VLANS=(114 124)
LINUX_NETMASKS=(192.168.114.2/24 192.168.124.2/24)
LINUX_NETMASKS_V6=(fd84::2/64 fd94::2/64)
LINUX_FIREWALL=()
LINUX_ROUTE_NETWORKS=(192.168.116.0/24 192.168.126.0/24)
LINUX_ROUTE_NETWORKS_V6=(fd86::/64 fd96::/64)
LINUX_ROUTE_VIA=(192.168.114.1 192.168.124.1)
LINUX_ROUTE_VIA_V6=(fd84::1 fd94::1)
