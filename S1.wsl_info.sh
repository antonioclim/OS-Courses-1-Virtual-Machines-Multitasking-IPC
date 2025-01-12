#!/bin/bash
# Save as S1.wsl_info.sh

echo "=== WSL Integration Points ==="
echo "1. Network Information:"
ip addr show

echo -e "\n2. Windows Path Integration:"
echo $PATH | tr ':' '\n' | grep -i 'windows'

echo -e "\n3. Mount Points:"
mount | grep -i 'windows'

echo -e "\n4. Process Integration:"
ps aux | grep -i '[w]slhost'

echo -e "\n5. System Resources:"
cat /proc/meminfo | head -n 5
cat /proc/cpuinfo | grep -E "processor|model name" | head -n 4
