#!/bin/sh
set -e

# ================================
# DYZULK CA UNINSTALLER
# Target : Ubuntu 20.04+ / 22.04 / 24.04
# Author : dyzulk.com
# ================================

CA_DIR="/usr/local/share/ca-certificates/dyzulk"
ROOT_CA_FILE="$CA_DIR/dyzulk-root-ca.crt"
INT_CA_FILE="$CA_DIR/dyzulk-intermediate-ca.crt"
FULL_CHAIN_FILE="$CA_DIR/dyzulk-full-chain.crt"

echo "[INFO] DYZULK CA Uninstaller starting..."

# Pastikan dijalankan sebagai root
if [ "$(id -u)" -ne 0 ]; then
    echo "[ERROR] Script harus dijalankan sebagai root."
    echo "Gunakan: sudo bash uninstall.sh"
    exit 1
fi

# Hapus file CA jika ada
echo "[INFO] Menghapus file CA DYZULK..."

[ -f "$ROOT_CA_FILE" ] && rm -f "$ROOT_CA_FILE" && echo " - Root CA dihapus"
[ -f "$INT_CA_FILE" ] && rm -f "$INT_CA_FILE" && echo " - Intermediate CA dihapus"
[ -f "$FULL_CHAIN_FILE" ] && rm -f "$FULL_CHAIN_FILE" && echo " - Full chain dihapus"

# Hapus direktori jika kosong
if [ -d "$CA_DIR" ] && [ -z "$(ls -A "$CA_DIR")" ]; then
    rmdir "$CA_DIR"
    echo " - Direktori CA dihapus"
fi

# Update trust store
echo "[INFO] Memperbarui trust store sistem..."
update-ca-certificates --fresh >/dev/null

echo "[SUCCESS] DYZULK Root & Intermediate CA berhasil dihapus."
echo "[INFO] Sistem tidak lagi mempercayai CA DYZULK."
