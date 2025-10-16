#!/bin/bash
PORT=${1:-4040}

echo "Installing DVWA on Linux/Kali..."

# Update system
sudo apt update

# Install dependencies
sudo apt install -y docker.io docker-compose git curl

# Start Docker
sudo systemctl start docker
sudo systemctl enable docker

# Add user to docker group
sudo usermod -aG docker $USER

# Create DVWA directory
mkdir -p ~/dvwa-setup && cd ~/dvwa-setup

# Download docker-compose
cat > docker-compose.yml << 'EOF'
version: '3.8'
services:
  dvwa:
    image: vulnerables/web-dvwa
    ports:
      - "PORT_PLACEHOLDER:80"
    environment:
      - MYSQL_ROOT_PASSWORD=dvwa
      - MYSQL_DATABASE=dvwa
      - MYSQL_USER=dvwa
      - MYSQL_PASSWORD=p@ssw0rd
    volumes:
      - dvwa_data:/var/lib/mysql
    restart: unless-stopped

volumes:
  dvwa_data:
EOF

# Replace port placeholder
sed -i "s/PORT_PLACEHOLDER/$PORT/g" docker-compose.yml

# Start DVWA
sudo docker-compose up -d

echo "DVWA installed successfully!"
echo "Access DVWA at: http://localhost:$PORT"
echo "Default credentials: admin/password"
echo "Setup database by clicking 'Create/Reset Database' button"
