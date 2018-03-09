#!/bin/bash

DPDK_VERSION=17.08
DPDK_CARD_IDS=
DPDK_CARD_NAMES=

LINUX_DRIVER=i40e
LINUX_CARD_IDS=(06:00.1)
LINUX_CARD_NAMES=(ens785f1)
LINUX_VLANS=(114)
LINUX_NETMASKS=(192.168.114.2/24)
LINUX_FIREWALL=
LINUX_ROUTE_NETWORKS=(192.168.116.0/24)
LINUX_ROUTE_VIA=(192.168.114.1)
