#!/usr/bin/env bash
set -euo pipefail

echo "=== EC2 Health Check ==="
echo "Hostname: $(hostname)"
echo "Current user: $(whoami)"

echo "=== System Uptime ==="
uptime

echo "=== Disk Usage ==="
df -h /

echo "=== Memory Usage ==="
free -h

echo "Health check completed successfully!"
