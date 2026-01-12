# 🔥 Linux Firewall Script

![Shell](https://img.shields.io/badge/Shell-Bash-green.svg)
![Platform](https://img.shields.io/badge/Platform-Linux-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

## Overview

This project provides a simple, clean, and customizable `iptables`-based firewall script for Linux servers. It is designed to offer secure defaults with easy customization, making it suitable for a wide range of server configurations. The script follows a security-first approach by dropping all incoming traffic by default and only allowing explicitly defined connections.

## Features

*   **Secure Defaults**: Drops all incoming and forwarding traffic by default, providing a strong security posture out of the box.
*   **Easy Configuration**: Simple array-based configuration for defining allowed TCP and UDP ports.
*   **Protocol Support**: Supports both TCP and UDP port rules, allowing for flexible configuration based on application needs.
*   **ICMP Control**: Optional configuration to enable or disable ICMP (ping) responses.
*   **Stateful Filtering**: Allows established and related connections, ensuring that ongoing legitimate traffic is not interrupted.
*   **Loopback Support**: Permits all traffic on the loopback interface, essential for local services and inter-process communication.
*   **Clean & Readable**: A well-documented and organized Bash script that is easy to understand and modify.

## Quick Start

### Installation

1.  **Clone the repository**:
    ```bash
    git clone https://github.com/BlackOussema/firewall-.git
    cd firewall-
    ```

2.  **Make the script executable**:
    ```bash
    chmod +x firewall.sh
    ```

3.  **Run the script** (requires root privileges):
    ```bash
    sudo ./firewall.sh
    ```

### Basic Usage

*   **Apply firewall rules**:
    ```bash
    sudo ./firewall.sh
    ```

*   **Check current rules**:
    ```bash
    sudo iptables -L -n -v
    ```

## Configuration

To customize the firewall rules, edit the `firewall.sh` script directly.

### Allowed Ports

Define the TCP and UDP ports you want to open in the `ALLOWED_PORTS` array:

```bash
ALLOWED_PORTS=(
    "tcp:22"    # SSH (essential for remote access)
    "tcp:80"    # HTTP
    "tcp:443"   # HTTPS
    "tcp:3306"  # MySQL (add if needed)
    "udp:53"    # DNS (add if needed)
)
```

### ICMP (Ping)

Control whether your server responds to ping requests by setting the `ALLOW_PING` variable:

```bash
# Enable ping responses
ALLOW_PING=true

# Disable ping responses (for a stealthier profile)
ALLOW_PING=false
```

## Default Rules Summary

| Rule                 | Description                                       |
|----------------------|---------------------------------------------------|
| `INPUT DROP`         | Block all incoming traffic by default.            |
| `FORWARD DROP`       | Block all traffic being forwarded through the server. |
| `OUTPUT ACCEPT`      | Allow all outgoing traffic from the server.       |
| `Loopback ACCEPT`    | Allow all traffic on the localhost interface.     |
| `ESTABLISHED ACCEPT` | Allow traffic for existing, established connections. |
| `TCP 22 ACCEPT`      | Allow SSH access (if configured).                 |
| `TCP 80 ACCEPT`      | Allow HTTP traffic (if configured).               |
| `TCP 443 ACCEPT`     | Allow HTTPS traffic (if configured).              |
| `ICMP ACCEPT`        | Allow ping responses (if configured).             |

## Common Configurations

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

### Game Server (Example)

```bash
ALLOWED_PORTS=(
    "tcp:22"    # SSH
    "udp:27015" # Source Engine (UDP)
    "tcp:27015" # Source Engine (TCP)
)
```

## How It Works

The script follows a systematic approach to apply firewall rules:

1.  **Flush Rules**: Clears all existing `iptables` rules to ensure a clean state.
2.  **Set Policies**: Configures the default policies for `INPUT`, `FORWARD`, and `OUTPUT` chains.
3.  **Allow Loopback**: Permits all communication on the loopback interface (`lo`).
4.  **Allow Established Connections**: Allows traffic that is part of an already established connection.
5.  **Open Ports**: Iterates through the `ALLOWED_PORTS` array and adds rules for each configured port.
6.  **ICMP Handling**: Optionally allows incoming ICMP (ping) requests based on the `ALLOW_PING` setting.

## Security Best Practices

### Before Applying

1.  **Ensure SSH Access**: Double-check that your SSH port (usually `tcp:22`) is included in the `ALLOWED_PORTS` array to avoid locking yourself out.
2.  **Test Locally**: If possible, test the script on a non-production server or a local virtual machine first.
3.  **Have Console Access**: Ensure you have console access (physical or through a cloud provider) to your server in case you get locked out.
4.  **Backup Current Rules**: Save your existing firewall rules before applying new ones.

### Backup & Restore

```bash
# Backup current iptables rules
sudo iptables-save > ~/iptables-backup.rules

# Restore from backup if needed
sudo iptables-restore < ~/iptables-backup.rules
```

### Persistence

By default, `iptables` rules are lost on reboot. To make them persistent:

*   **Debian/Ubuntu**:
    ```bash
    sudo apt install iptables-persistent
    sudo netfilter-persistent save
    ```

*   **CentOS/RHEL**:
    ```bash
    sudo service iptables save
    ```

*   **Using `rc.local`** (less common now):
    Add the following line to `/etc/rc.local`:
    `/path/to/firewall.sh`

## Troubleshooting

### Locked Out?

If you accidentally lock yourself out of your server:

1.  Access the server via a console (physical or cloud-based).
2.  Flush all `iptables` rules: `sudo iptables -F`
3.  Reset the default `INPUT` policy to `ACCEPT`: `sudo iptables -P INPUT ACCEPT`
4.  Fix the configuration in `firewall.sh` and re-apply the rules.

### Check Rules

```bash
# List all rules with verbose output
sudo iptables -L -n -v

# List rules with line numbers for easy reference
sudo iptables -L --line-numbers

# Check a specific chain (e.g., INPUT)
sudo iptables -L INPUT -n -v
```

### Test Connectivity

From another machine, use a tool like `nmap` or `netcat` to test connectivity to the configured ports:

```bash
# Test SSH port
nc -zv your-server-ip 22

# Test HTTP port
nc -zv your-server-ip 80
```

## Project Structure

```
firewall-/
├── firewall.sh    # The main firewall script
└── README.md      # Project documentation (this file)
```

## Disclaimer

**Use this script at your own risk.**

*   Always test firewall configurations in a non-production environment first.
*   Ensure you have alternative access (e.g., a console) to your server before applying new rules.
*   The author is not responsible for any lockouts, service disruptions, or security issues that may arise from the use of this script.
*   Thoroughly review and understand the rules before applying them to a production system.

## Contributing

Contributions and suggestions are welcome! Some ideas for improvement include:

*   Adding IPv6 support.
*   Creating an interactive configuration wizard.
*   Implementing logging rules for dropped packets.
*   Adding rate limiting to prevent brute-force attacks.
*   Integrating with tools like `fail2ban`.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for full details.

## Author

**Ghariani Oussema**
*   GitHub: [@BlackOussema](https://github.com/BlackOussema)
*   Role: Cybersecurity Researcher & Full-Stack Developer
*   Location: Tunisia 🇹🇳

---

<p align="center">
  Made with ❤️ in Tunisia 🇹🇳
</p>
