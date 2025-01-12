#!/bin/bash
# Save as docker_service_manager.sh

# Disable systemctl pager
export SYSTEMD_PAGER=""

# Function to check if running in WSL
is_wsl() {
    if grep -qi microsoft /proc/version; then
        return 0  # true
    else
        return 1  # false
    fi
}

# Function to check service status
check_status() {
    echo "=== Docker Status ==="
    if sudo service docker status 2>/dev/null | cat; then
        echo "Docker service is running"
    else
        echo "Docker service is not running"
    fi
    
    echo -e "\n=== Docker Process Status ==="
    if pgrep -f dockerd >/dev/null; then
        echo "Docker daemon is running"
        ps aux | grep -v grep | grep dockerd
    else
        echo "Docker daemon is not running"
    fi

    echo -e "\n=== Docker Socket Status ==="
    if [ -S "/var/run/docker.sock" ]; then
        echo "Docker socket exists:"
        ls -l /var/run/docker.sock
    else
        echo "Docker socket not found"
    fi
}

# Function to stop Docker completely
stop_docker() {
    echo "Stopping Docker..."
    
    # Stop the service
    sudo service docker stop 2>/dev/null | cat
    
    # Kill any remaining docker processes
    if pgrep -f docker > /dev/null; then
        echo "Stopping Docker processes..."
        sudo pkill -f docker
        sudo pkill -f containerd
    fi
    
    # Wait a moment for processes to stop
    sleep 2
    
    check_status
}

# Function to start Docker
start_docker() {
    echo "Starting Docker..."
    
    # Make sure containerd is started first
    sudo service containerd start 2>/dev/null | cat
    sleep 1
    
    # Start Docker service
    sudo service docker start 2>/dev/null | cat
    sleep 2
    
    # Verify if service started correctly
    if ! pgrep -f dockerd >/dev/null; then
        echo "Docker failed to start normally, attempting alternative start..."
        sudo dockerd > /dev/null 2>&1 &
        sleep 3
    fi
    
    check_status

    # Test if Docker is responding
    if docker info >/dev/null 2>&1; then
        echo "Docker is now operational"
    else
        echo "Warning: Docker may not be fully operational"
    fi
}

# Function to restart Docker
restart_docker() {
    echo "Restarting Docker..."
    stop_docker
    sleep 2
    start_docker
}

# Function to check if Docker is functioning
test_docker() {
    echo "Testing Docker functionality..."
    if docker info >/dev/null 2>&1; then
        echo "Docker is functioning correctly"
        echo -e "\nDocker Information:"
        docker info | grep -E "Server Version|Containers:|Images:|OS Type:|Kernel Version"
        echo -e "\nTesting with hello-world container..."
        docker run --rm hello-world
    else
        echo "Docker is not responding"
        echo "Status details:"
        check_status
        echo -e "\nTroubleshooting steps:"
        echo "1. Try restarting Docker"
        echo "2. Check if Docker service is enabled"
        echo "3. Verify WSL2 integration is working"
    fi
}

# Menu
while true; do
    echo -e "\n=== Docker Service Manager (WSL2) ==="
    echo "1. Start Docker"
    echo "2. Stop Docker"
    echo "3. Restart Docker"
    echo "4. Check Status"
    echo "5. Test Docker"
    echo "6. Exit"
    
    read -p "Choose option: " option
    
    case $option in
        1) start_docker ;;
        2) stop_docker ;;
        3) restart_docker ;;
        4) check_status ;;
        5) test_docker ;;
        6) break ;;
        *) echo "Invalid option" ;;
    esac

    # Add a small delay before showing the menu again
    sleep 1
done
