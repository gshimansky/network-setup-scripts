#!/bin/bash

DPDK_CARD_IDS=(06:00.0 06:00.1 81:00.0 81:00.1 81:00.2 81:00.3)
DPDK_CARD_NAMES=(ens785f0 ens785f1 ens787f0 ens787f1 ens787f2 ens787f3)

LINUX_DRIVER=
LINUX_CARD_IDS=
LINUX_CARD_NAMES=
LINUX_NETMASKS=
LINUX_FIREWALL=
LINUX_ROUTE_NETWORKS=
LINUX_ROUTE_VIA=
