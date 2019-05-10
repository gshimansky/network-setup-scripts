sudo nmcli c add type ethernet ifname ens6 con-name static-ens6 ip4 192.168.14.2/24 ip6 fd14::2/64 ipv4.routes "192.168.16.0/24 192.168.14.1, 192.168.18.0/24 192.168.14.1" ipv6.routes "fd16::/64 fd14::1, fd18::/64 fd14::1"

sudo nmcli c add type ethernet ifname ens7 con-name static-ens7 ip4 192.168.24.2/24 ip6 fd24::2/64 ipv4.routes "192.168.26.0/24 192.168.24.1, 192.168.28.0/24 192.168.24.1" ipv6.routes "fd26::/64 fd24::1, fd28::/64 fd24::1"
