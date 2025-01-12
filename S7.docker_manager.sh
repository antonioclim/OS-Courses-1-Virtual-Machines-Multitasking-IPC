#!/bin/bash
# Save as docker_manager.sh

# Ensure Docker is running
ensure_docker() {
    # Check if docker group exists and user is in it
    if ! groups | grep -q docker; then
        echo "Error: Current user is not in the docker group."
        echo "Run: sudo usermod -aG docker $USER"
        echo "Then log out and log back in."
        exit 1
    fi

    # Check if Docker daemon is running
    if ! docker info >/dev/null 2>&1; then
        echo "Starting Docker service..."
        sudo service docker start
        sleep 2
        
        # Check again
        if ! docker info >/dev/null 2>&1; then
            echo "Error: Could not start Docker service."
            exit 1
        fi
    fi
}

# Basic container management
create_test_container() {
    ensure_docker
    echo "=== Creating Test Container ==="
    if docker ps -a | grep -q "test-nginx"; then
        echo "Container 'test-nginx' already exists. Removing it..."
        docker rm -f test-nginx
    fi
    docker run -d --name test-nginx \
        -p 8080:80 \
        nginx:latest
    
    if [ $? -eq 0 ]; then
        echo "Container created successfully!"
        echo "Access nginx at http://localhost:8080"
    else
        echo "Failed to create container!"
    fi
}

show_containers() {
    ensure_docker
    echo "=== Active Containers ==="
    docker ps -a || echo "Failed to list containers!"
}

container_stats() {
    ensure_docker
    echo "=== Container Statistics ==="
    if [ "$(docker ps -q)" ]; then
        docker stats --no-stream
    else
        echo "No running containers found!"
    fi
}

cleanup_containers() {
    ensure_docker
    echo "=== Cleaning Up ==="
    if [ "$(docker ps -aq)" ]; then
        docker stop $(docker ps -aq)
        docker rm $(docker ps -aq)
        echo "All containers removed."
    else
        echo "No containers to clean up."
    fi
}

# Menu
while true; do
    echo -e "\n=== Docker Management ==="
    echo "1. Create test container"
    echo "2. Show containers"
    echo "3. Show container stats"
    echo "4. Cleanup containers"
    echo "5. Exit"
    
    read -p "Choose option: " option
    
    case $option in
        1) create_test_container ;;
        2) show_containers ;;
        3) container_stats ;;
        4) cleanup_containers ;;
        5) break ;;
        *) echo "Invalid option" ;;
    esac
done
