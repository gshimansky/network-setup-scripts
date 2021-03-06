#!/bin/bash

DPDK_CARD_IDS=
DPDK_CARD_NAMES=

LINUX_DRIVER=ena
LINUX_CARD_IDS=(00:06.0 00:07.0)
LINUX_CARD_NAMES=(ens6 ens7)
LINUX_NETMASKS=(10.0.16.20/24 10.0.26.20/24)
LINUX_NETMASKS_V6=(2600:1f16:80:ad16::20/64 2600:1f16:80:ad26::20/64)
LINUX_FIREWALL=()
LINUX_ROUTE_NETWORKS=()
LINUX_ROUTE_NETWORKS_V6=(2600:1f16:80:ad14::/64 2600:1f16:80:ad24::/64)
LINUX_ROUTE_VIA=()
LINUX_ROUTE_VIA_V6=(2600:1f16:80:ad16::10 2600:1f16:80:ad26::10)
