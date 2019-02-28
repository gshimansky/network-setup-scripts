sudo nmcli c add type ethernet ifname ens6 con-name static-ens6 ip4 10.0.14.20/24 ip6 2600:1f16:80:ad14::20/64 ipv4.routes "10.0.16.0/24 10.0.14.10, 10.0.18.0/24 10.0.14.10" ipv6.routes "2600:1f16:80:ad16::/64 2600:1f16:80:ad14::10, 2600:1f16:80:ad18::/64 2600:1f16:80:ad14::10"

sudo nmcli c add type ethernet ifname ens7 con-name static-ens7 ip4 10.0.24.20/24 ip6 2600:1f16:80:ad24::20/64 ipv4.routes "10.0.26.0/24 10.0.24.10, 10.0.28.0/24 10.0.24.10" ipv6.routes "2600:1f16:80:ad26::/64 2600:1f16:80:ad24::10, 2600:1f16:80:ad28::/64 2600:1f16:80:ad24::10"
