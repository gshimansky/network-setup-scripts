#!/bin/bash

DPDK_CARD_IDS=
DPDK_CARD_NAMES=

LINUX_DRIVER=ena
LINUX_CARD_IDS=(00:06.0 00:07.0)
LINUX_CARD_NAMES=(ens6 ens7)
LINUX_NETMASKS=(10.0.14.200/24 10.0.24.200/24)
LINUX_FIREWALL=
LINUX_ROUTE_NETWORKS=(10.0.16.0/24 10.0.26.0/24)
LINUX_ROUTE_VIA=(10.0.14.10 10.0.24.10)
