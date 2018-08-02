# network-setup-scripts
Scripts used to setup performance tests of NFF-Go on various lab
machines. Use it like this:
```
$ sudo -E ./reconfigure.sh ./lv/virtio/nat/client.sh
```
Required environenment variables is `NFF_GO` which should point to
NFF-Go repository root with built DPDK.

## Configuration files syntax

You need to specify settings either for DPDK cards, LINUX cards or for
both. Number of cards in all arrays of a group has to be the
same.

### DPDK cards configuration
- *DPDK_VERSION* - specifies dpdk version which is used by NFF-Go,
e.g. 17.08.
- *DPDK_CARD_IDS* - PCI IDs of cards that have to be bound to DPDK
driver igb_uio, e.g. 00:08.0.
- *DPDK_CARD_NAMES* - Linux interface names for cards that have to be
bound to DPDK driver, e.g. eth1.

### LINUX cards configuration
- *LINUX_DRIVER* - name of Linux kernel driver to be used for these
cards, e.g. i40e.
- *LINUX_CARD_IDS* - PCI IDs of cards that have to be bound to Linux
kernel driver, e.g. 00:09.0.
- *LINUX_CARD_NAMES* - Linux interface names for cards that have to be
to Linux kernel driver, e.g. enp0s9.
- *LINUX_NETMASKS* - IPv4 address and netmask for network interface,
e.g. 192.168.24.1/24.
- *LINUX_FIREWALL* - Specifies whether it is necessary to do packet
forwarding from first card to second. First card is meant to be
private network interface, second card is meant to be public network
interface. Works only for two cards. To enable setting, set it to 1,
otherwise leave empty value.
- *LINUX_ROUTE_NETWORKS* - Specifies which other networks should be
reacheable via network interface, e.g. 192.168.16.0/24.
- *LINUX_ROUTE_VIA* - Specifies which IP address to use to reach another
network, e.g. 192.168.14.1.
