#!/bin/bash

LINUX_DRIVER=e1000
DPDK_VERSION=17.08
DPDK_CARD_IDS=
DPDK_CARD_NAMES=
LINUX_CARD_IDS=(00:08.0 00:09.0)
LINUX_CARD_NAMES=(enp0s8 enp0s9)
LINUX_NETMASKS=(192.168.14.2/24 192.168.24.2/24)
LINUX_ROUTE_NETWORKS=(192.168.16.0/24 192.168.26.0/24)
LINUX_ROUTE_VIA=(192.168.14.1 192.168.24.1)
