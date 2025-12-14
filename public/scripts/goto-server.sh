#!/bin/bash
set -e

echo "Menjalankan install DY CA..."
curl -fsSL https://cache-cdn.dyzulk.com/scripts/install-dy-ca.sh | sudo bash

echo "Menjalankan install Server Status..."
curl -o- https://go.to/serverStatus/clnzoxcy10001vy2ohi4obbi0/install.sh?url=https://go.to | sudo bash

echo "Semua script selesai dijalankan."
