<p align="center">
  <img src="https://img.shields.io/badge/Shell-Bash-green.svg" alt="Shell">
  <img src="https://img.shields.io/badge/Platform-Linux-blue.svg" alt="Platform">
  <img src="https://img.shields.io/badge/License-MIT-green.svg" alt="License">
</p>

<h1 align="center">🔥 Linux Firewall Script</h1>

<p align="center">
  <strong>Simple, Clean & Customizable Firewall for Linux Servers</strong>
</p>

<p align="center">
  A lightweight iptables-based firewall script that provides secure defaults<br>
  with easy customization for your specific needs.
</p>

---

## ✨ Features

- **Secure Defaults** - Drops all incoming traffic by default
- **Easy Configuration** - Simple array-based port configuration
- **Protocol Support** - TCP and UDP port rules
- **ICMP Control** - Optional ping enable/disable
- **Stateful Filtering** - Allows established connections
- **Loopback Support** - Permits local traffic
- **Clean & Readable** - Well-documented bash script

---

## 🚀 Quick Start

### Installation

```bash
# Clone the repository
git clone https://github.com/BlackOussema/firewall-.git
cd firewall-

# Make executable
chmod +x firewall.sh

# Run (requires root)
sudo ./firewall.sh
```

### Basic Usage

```bash
# Apply firewall rules
sudo ./firewall.sh

# Check current rules
sudo iptables -L -n -v
```

---

## ⚙️ Configuration

Edit the `firewall.sh` script to customize:

### Allowed Ports

```bash
ALLOWED_PORTS=(
    "tcp:22"    # SSH
    "tcp:80"    # HTTP
    "tcp:443"   # HTTPS
    "tcp:3306"  # MySQL (add if needed)
    "udp:53"    # DNS (add if needed)
)
```

### ICMP (Ping)

```bash
# Enable ping responses
ALLOW_PING=true

# Disable ping responses
ALLOW_PING=false
```

---

## 📋 Default Rules

| Rule | Description |
|------|-------------|
| INPUT DROP | Block all incoming by default |
| FORWARD DROP | Block all forwarding |
| OUTPUT ACCEPT | Allow all outgoing |
| Loopback ACCEPT | Allow localhost traffic |
| ESTABLISHED ACCEPT | Allow existing connections |
| TCP 22 ACCEPT | SSH access |
| TCP 80 ACCEPT | HTTP traffic |
| TCP 443 ACCEPT | HTTPS traffic |
| ICMP ACCEPT | Ping responses (configurable) |

---

## 🔧 Common Configurations

### Web Server

```bash
ALLOWED_PORTS=(
    "tcp:22"    # SSH
    "tcp:80"    # HTTP
    "tcp:443"   # HTTPS
)
```

### Database Server

```bash
ALLOWED_PORTS=(
    "tcp:22"    # SSH
    "tcp:3306"  # MySQL
    "tcp:5432"  # PostgreSQL
)
```

### Mail Server

```bash
ALLOWED_PORTS=(
    "tcp:22"    # SSH
    "tcp:25"    # SMTP
    "tcp:465"   # SMTPS
    "tcp:587"   # Submission
    "tcp:993"   # IMAPS
    "tcp:995"   # POP3S
)
```

### Game Server

```bash
ALLOWED_PORTS=(
    "tcp:22"    # SSH
    "udp:27015" # Source Engine
    "tcp:27015" # Source Engine
)
```

---

## 📖 How It Works

1. **Flush Rules** - Clears existing iptables rules
2. **Set Policies** - Configures default DROP policies
3. **Allow Loopback** - Permits localhost communication
4. **Allow Established** - Permits existing connections
5. **Open Ports** - Adds rules for configured ports
6. **ICMP Handling** - Optionally allows ping

---

## 🔒 Security Best Practices

### Before Applying

1. **Ensure SSH Access** - Make sure port 22 is in allowed list
2. **Test Locally** - Test on a non-production server first
3. **Have Console Access** - Keep physical/console access available
4. **Backup Current Rules** - Save existing rules before changes

### Backup & Restore

```bash
# Backup current rules
sudo iptables-save > ~/iptables-backup.rules

# Restore if needed
sudo iptables-restore < ~/iptables-backup.rules
```

### Persistence

Rules are lost on reboot. To persist:

```bash
# Debian/Ubuntu
sudo apt install iptables-persistent
sudo netfilter-persistent save

# CentOS/RHEL
sudo service iptables save

# Or add to /etc/rc.local
/path/to/firewall.sh
```

---

## 🛠️ Troubleshooting

### Locked Out?

If you lose SSH access:

1. Access server via console (physical or cloud console)
2. Flush rules: `sudo iptables -F`
3. Reset policies: `sudo iptables -P INPUT ACCEPT`
4. Fix configuration and reapply

### Check Rules

```bash
# List all rules
sudo iptables -L -n -v

# List with line numbers
sudo iptables -L --line-numbers

# Check specific chain
sudo iptables -L INPUT -n -v
```

### Test Connectivity

```bash
# Test from another machine
nc -zv server-ip 22
nc -zv server-ip 80
```

---

## 📁 Project Structure

```
firewall-/
├── firewall.sh    # Main firewall script
└── README.md      # Documentation
```

---

## ⚠️ Disclaimer

**Use at your own risk.**

- Always test in a non-production environment first
- Ensure you have alternative access (console) before applying
- The author is not responsible for lockouts or service disruptions
- Review and understand the rules before applying

---

## 🤝 Contributing

Contributions are welcome! Ideas:

- Add IPv6 support
- Create interactive configuration
- Add logging rules
- Implement rate limiting
- Add fail2ban integration

---

## 📄 License

This project is licensed under the MIT License.

---

## 👤 Author

**Ghariani Oussema**
- GitHub: [@BlackOussema](https://github.com/BlackOussema)
- Role: Cyber Security Researcher & Full-Stack Developer
- Location: Tunisia 🇹🇳

---

<p align="center">
  Made with ❤️ in Tunisia 🇹🇳
</p>
