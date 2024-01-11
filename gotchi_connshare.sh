#!/usr/bin/env bash
set -e

# Ask for the username
read -p "Enter username for pwnagotchi: " username

# Construct the pwnagotchi ip address for ssh connection with the provided username
GOTCHI_ADDR="${username}@10.0.0.2"

# Ask for DNS IP address with suggestions
echo "Enter the DNS IP address you want to use (suggested: 1.1.1.1, 8.8.8.8, 9.9.9.9)"
read -p "DNS IP Address: " YOUR_DNS
YOUR_DNS=${YOUR_DNS:-"1.1.1.1"} # Default to 1.1.1.1 if no input is provided

# Scan for Ethernet gadget interfaces
echo "Scanning for Ethernet gadget interfaces..."
gadget_interfaces=$(ls /sys/class/net | grep -E 'enx|eth')

if [ -z "$gadget_interfaces" ]; then
    echo "No Ethernet gadget interfaces found."
    exit 1
fi

echo "Available Ethernet gadget interfaces:"
select USB_IFACE in $gadget_interfaces; do
    if [ -n "$USB_IFACE" ]; then
        break
    else
        echo "Invalid selection. Please try again."
    fi
done

# Scan for non-Ethernet gadget interfaces
echo "Scanning for non-Ethernet gadget interfaces..."
non_gadget_interfaces=$(ls /sys/class/net | grep -vE 'enx|eth|lo')

if [ -z "$non_gadget_interfaces" ]; then
    echo "No non-Ethernet gadget interfaces found."
    exit 1
fi

echo "Available non-Ethernet gadget interfaces:"
select UPSTREAM_IFACE in $non_gadget_interfaces; do
    if [ -n "$UPSTREAM_IFACE" ]; then
        break
    else
        echo "Invalid selection. Please try again."
    fi
done

USB_IFACE_IP=10.0.0.1
USB_IFACE_NET=10.0.0.0/24

ip addr flush "$USB_IFACE"

ip addr add "$USB_IFACE_IP/24" dev "$USB_IFACE"
ip link set "$USB_IFACE" up

iptables -A FORWARD -o "$UPSTREAM_IFACE" -i "$USB_IFACE" -s "$USB_IFACE_NET" -m conntrack --ctstate NEW -j ACCEPT
iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -t nat -F POSTROUTING
iptables -t nat -A POSTROUTING -o "$UPSTREAM_IFACE" -j MASQUERADE

echo 1 > /proc/sys/net/ipv4/ip_forward

ssh "$GOTCHI_ADDR" "echo nameserver $YOUR_DNS | sudo tee -a /etc/resolv.conf"
