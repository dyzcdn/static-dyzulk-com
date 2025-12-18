#!/bin/bash
set -e

PORTS=(80 443 888 887 8288 8290 8289 8188 7080)

echo "=== aaPanel Multi Webserver Port Enabler ==="

open_ports_firewalld() {
    echo "[INFO] firewalld detected"
    for port in "${PORTS[@]}"; do
        firewall-cmd --permanent --add-port=${port}/tcp
    done
    firewall-cmd --reload
}

open_ports_ufw() {
    echo "[INFO] UFW detected"
    ufw --force enable
    for port in "${PORTS[@]}"; do
        ufw allow ${port}/tcp
    done
    ufw reload
}

open_ports_iptables() {
    echo "[INFO] iptables detected"
    for port in "${PORTS[@]}"; do
        iptables -I INPUT -p tcp --dport ${port} -j ACCEPT
        iptables -I OUTPUT -p tcp --sport ${port} -j ACCEPT
    done

    if command -v netfilter-persistent >/dev/null 2>&1; then
        netfilter-persistent save
    elif command -v service >/dev/null 2>&1; then
        service iptables save || true
    fi
}

if command -v firewall-cmd >/dev/null 2>&1; then
    open_ports_firewalld
elif command -v ufw >/dev/null 2>&1; then
    open_ports_ufw
else
    open_ports_iptables
fi

echo "=========================================="
echo "All required ports have been opened:"
printf '%s\n' "${PORTS[@]}"
echo "Done."
