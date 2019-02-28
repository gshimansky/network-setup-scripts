sudo nmcli c add type ethernet ifname ens7 con-name static-ens7 ip4 10.0.24.10/24 ip6 2600:1f16:80:ad24::10/64
sudo nmcli c add type ethernet ifname ens9 con-name static-ens9 ip4 10.0.26.10/24 ip6 2600:1f16:80:ad26::10/64
sudo nmcli c add type ip-tunnel ifname gre2 con-name static-gre2 ip-tunnel.mode gre ip-tunnel.local 10.0.26.10 ip-tunnel.remote 10.0.26.20 ip4 10.0.28.10/24 ip6 2600:1f16:80:ad28::10/64

sudo sysctl -w net.ipv4.ip_forward=1
sudo sysctl -w net.ipv6.conf.default.forwarding=1
sudo sysctl -w net.ipv6.conf.all.forwarding=1

