sudo sysctl -w net.ipv4.conf.default.rp_filter=2
sudo sysctl -w net.ipv4.conf.all.rp_filter=2

sudo nmcli c add type ethernet ifname ens6 con-name static-ens6 ip4 192.168.16.3/24 ip6 fd16::3/64 ipv4.routes 192.168.14.0/24 ipv6.routes fd14::/64
sudo nmcli c add type ip-tunnel ifname gre1 con-name static-gre1 ip-tunnel.mode gre ip-tunnel.local 192.168.16.3 ip-tunnel.remote 192.168.16.1 ip4 192.168.18.2/24 ip6 fd18::2/64
