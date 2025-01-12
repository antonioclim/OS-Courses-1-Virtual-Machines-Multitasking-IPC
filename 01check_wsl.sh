#!/bin/bash
# Save as check_wsl.sh

echo "=== WSL Environment Check ==="
echo "WSL Version:"
wsl.exe --version

echo -e "\n=== Linux Version ==="
uname -a

echo -e "\n=== Ubuntu Version ==="
lsb_release -a

echo -e "\n=== Memory Available ==="
free -h

echo -e "\n=== CPU Information ==="
lscpu

echo -e "\n=== Disk Space ==="
df -h
