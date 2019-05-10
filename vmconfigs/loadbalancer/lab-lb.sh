sudo nmcli c add type ethernet ifname ens7 con-name static-ens7 ip4 192.168.24.1/24 ip6 fd24::1/64
sudo nmcli c add type ethernet ifname ens9 con-name static-ens9 ip4 192.168.26.1/24 ip6 fd26::1/64
sudo nmcli c add type ip-tunnel ifname gre2 con-name static-gre2 ip-tunnel.mode gre ip-tunnel.local 192.168.26.1 ip-tunnel.remote 192.168.26.2 ip4 192.168.28.1/24 ip6 fd28::1/64

sudo sysctl -w net.ipv4.ip_forward=1
sudo sysctl -w net.ipv6.conf.default.forwarding=1
sudo sysctl -w net.ipv6.conf.all.forwarding=1

