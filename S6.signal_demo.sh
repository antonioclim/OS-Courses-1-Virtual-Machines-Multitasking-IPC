#!/bin/bash
# Save as signal_demo.sh

# Cleanup function
cleanup() {
    echo -e "\nCleaning up and exiting..."
    exit 0
}

# Signal handler function
handle_signal() {
    case $1 in
        SIGINT)
            echo -e "\nReceived SIGINT (Ctrl+C)"
            cleanup
            ;;
        SIGTERM)
            echo "Received SIGTERM"
            cleanup
            ;;
        SIGUSR1)
            echo "Received SIGUSR1"
            ;;
    esac
}

# Register signal handlers
trap 'handle_signal SIGINT' SIGINT
trap 'handle_signal SIGTERM' SIGTERM
trap 'handle_signal SIGUSR1' SIGUSR1

echo "=== Signal Demonstration ==="
echo "PID: $$"
echo "Try these commands in another terminal:"
echo "kill -SIGUSR1 $$"
echo "kill -SIGTERM $$"
echo "Or press Ctrl+C in this terminal"

# Counter for dots
count=0
max_dots=50

while true; do
    echo -n "."
    count=$((count + 1))
    
    # Start new line after max_dots
    if [ $count -eq $max_dots ]; then
        echo
        count=0
    fi
    
    sleep 1
done
