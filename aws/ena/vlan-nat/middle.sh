#!/bin/bash

DPDK_CARD_IDS=(00:06.0 00:08.0)
DPDK_CARD_NAMES=(ens6 ens8)

LINUX_DRIVER=ena
LINUX_CARD_IDS=(00:07.0 00:09.0)
LINUX_CARD_NAMES=(ens7 ens9 priv0 pub1)
LINUX_VLANS=(124 126 114 116)
LINUX_NETMASKS=(192.168.124.1/24 192.168.126.1/24 192.168.114.1/24 192.168.116.1/24)
LINUX_NETMASKS_V6=(fd94::1/64 fd96::1/64 fd84::1/64 fd86::1/64)
LINUX_FIREWALL=(ens7.124 ens9.126)
LINUX_ROUTE_NETWORKS=
LINUX_ROUTE_VIA=