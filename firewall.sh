#!/usr/bin/env bash

# Customizable Firewall Script
# Allows user-defined ports and blocks all other incoming connections

# ---------------------------
# CONFIGURATION
# Add or remove ports as needed
# Format: protocol:port
ALLOWED_PORTS=(
"tcp:22" # SSH
"tcp:80" # HTTP
"tcp:443" # HTTPS
)

ALLOW_PING=true
# ---------------------------

# Flush old rules
sudo iptables -F

# Default policies: DROP all incoming and forwarded traffic
sudo iptables -P INPUT DROP
sudo iptables -P FORWARD DROP
sudo iptables -P OUTPUT ACCEPT

# Allow loopback
sudo iptables -A INPUT -i lo -j ACCEPT

# Allow established and related connections
sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Open allowed ports
for rule in "${ALLOWED_PORTS[@]}"; do
IFS=":" read -r proto port <<< "$rule"
sudo iptables -A INPUT -p "$proto" --dport "$port" -j ACCEPT
done

# Allow ICMP if enabled
if [ "$ALLOW_PING" = true ]; then
sudo iptables -A INPUT -p icmp -j ACCEPT
fi

echo "Custom firewall activated successfully!"
