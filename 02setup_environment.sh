#!/bin/bash
# Save as 02setup_environment.sh

echo "=== Updating Package Lists ==="
sudo apt update

echo "=== Installing Essential Tools ==="
sudo apt install -y \
    build-essential \
    htop \
    net-tools \
    procps \
    iproute2 \
    tmux \
    tree \
    curl \
    wget \
    jq

echo "=== Installing Development Tools ==="
sudo apt install -y \
    git \
    make \
    bc \
    gawk

echo "=== Installing Container Tools ==="
# Install Docker
if ! command -v docker &> /dev/null; then
    echo "Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    rm get-docker.sh
fi

# Setup Docker in WSL
if ! systemctl status docker &> /dev/null; then
    echo "Setting up Docker service..."
    sudo mkdir -p /etc/docker
    sudo tee /etc/docker/daemon.json > /dev/null <<EOF
{
    "features": {
        "buildkit": true
    }
}
EOF
    # Create service override directory
    sudo mkdir -p /etc/systemd/system/docker.service.d
fi

echo "=== Verifying Installations ==="
for cmd in docker git make htop curl jq; do
    if command -v $cmd &> /dev/null; then
        echo "$cmd: Installed ✓"
    else
        echo "$cmd: Not found ✗"
    fi
done
