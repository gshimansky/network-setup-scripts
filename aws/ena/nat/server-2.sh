#!/bin/bash

DPDK_CARD_IDS=
DPDK_CARD_NAMES=

LINUX_DRIVER=ena
LINUX_CARD_IDS=(00:06.0 00:07.0)
LINUX_CARD_NAMES=(ens6 ens7)
LINUX_NETMASKS=(10.0.16.40/24 10.0.26.40/24)
LINUX_FIREWALL=
LINUX_ROUTE_NETWORKS=
LINUX_ROUTE_VIA=
