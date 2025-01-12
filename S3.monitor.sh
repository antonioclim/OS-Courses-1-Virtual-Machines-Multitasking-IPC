#!/bin/bash
# Save as S3.monitor.sh

monitor_processes() {
    while true; do
        clear
        echo "=== System Monitor ==="
        echo "Time: $(date)"
        echo -e "\n1. Top CPU Processes:"
        ps aux --sort=-%cpu | head -n 6

        echo -e "\n2. Memory Usage:"
        free -h

        echo -e "\n3. Disk Usage:"
        df -h | grep -v "loop"

        echo -e "\n4. Network Connections:"
        netstat -tun | head -n 5

        echo -e "\nPress Ctrl+C to exit..."
        sleep 2
    done
}

monitor_processes
