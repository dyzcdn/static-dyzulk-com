#!/bin/sh
set -e

# ================================
# DYZULK CA INSTALLER
# Target : Ubuntu 20.04+ / 22.04 / 24.04
# Author : dyzulk.com
# ================================

ROOT_CA_URL="https://app.dyzulk.com/download/ca/root"
INT_CA_URL="https://app.dyzulk.com/download/ca/intermediate"

CA_DIR="/usr/local/share/ca-certificates/dyzulk"
ROOT_CA_FILE="$CA_DIR/dyzulk-root-ca.crt"
INT_CA_FILE="$CA_DIR/dyzulk-intermediate-ca.crt"

echo "[INFO] DYZULK CA Installer starting..."

# Pastikan dijalankan sebagai root
if [ "$(id -u)" -ne 0 ]; then
    echo "[ERROR] Script harus dijalankan sebagai root."
    echo "Gunakan: curl -fsSL URL | sudo bash"
    exit 1
fi

# Buat direktori CA
echo "[INFO] Menyiapkan direktori CA..."
mkdir -p "$CA_DIR"

# Download Root CA
echo "[INFO] Mengunduh Root CA..."
curl -fsSL "$ROOT_CA_URL" -o "$ROOT_CA_FILE"

# Download Intermediate CA
echo "[INFO] Mengunduh Intermediate CA..."
curl -fsSL "$INT_CA_URL" -o "$INT_CA_FILE"

# Validasi sertifikat
echo "[INFO] Memverifikasi sertifikat..."

openssl x509 -in "$ROOT_CA_FILE" -noout >/dev/null 2>&1 || {
    echo "[ERROR] Root CA tidak valid."
    exit 1
}

openssl x509 -in "$INT_CA_FILE" -noout >/dev/null 2>&1 || {
    echo "[ERROR] Intermediate CA tidak valid."
    exit 1
}

# Update trust store
echo "[INFO] Memperbarui trust store sistem..."
update-ca-certificates

echo "[SUCCESS] DYZULK Root & Intermediate CA berhasil dipasang."
echo "[INFO] CA kini dipercaya oleh curl, apt, git, openssl."
