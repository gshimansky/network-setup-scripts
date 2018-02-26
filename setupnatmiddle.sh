#!/bin/bash

LINUX_DRIVER=e1000
DPDK_VERSION=17.08
DPDK_CARD_IDS=(00:08.0 00:0a.0)
DPDK_CARD_NAMES=(enp0s8 enp0s10)
LINUX_CARD_IDS=(00:09.0 00:10.0)
LINUX_CARD_NAMES=(enp0s9 enp0s16)
LINUX_NETMASKS=(192.168.24.1/24 192.168.26.1/24)
LINUX_FIREWALL=1
LINUX_ROUTE_NETWORKS=
LINUX_ROUTE_VIA=

. ./common.sh
