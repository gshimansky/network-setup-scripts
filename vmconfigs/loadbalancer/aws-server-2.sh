sudo sysctl -w net.ipv4.conf.default.rp_filter=2
sudo sysctl -w net.ipv4.conf.all.rp_filter=2

sudo nmcli c add type ethernet ifname ens6 con-name static-ens6 ip4 10.0.16.30/24 ip6 2600:1f16:80:ad16::30/64 ipv4.routes 10.0.14.0/24 ipv6.routes 2600:1f16:80:ad14::/64
sudo nmcli c add type ip-tunnel ifname gre1 con-name static-gre1 ip-tunnel.mode gre ip-tunnel.local 10.0.16.30 ip-tunnel.remote 10.0.16.10 ip4 10.0.18.20/24 ip6 2600:1f16:80:ad18::20/64

