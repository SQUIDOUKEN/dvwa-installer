#!/bin/bash
PORT=${1:-4040}

echo "Installing DVWA on macOS..."

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install dependencies
echo "Installing dependencies..."
brew install --cask docker
brew install git curl

echo "Please start Docker Desktop manually, then press Enter to continue..."
read -p "Press Enter when Docker Desktop is running..."

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
sed -i '' "s/PORT_PLACEHOLDER/$PORT/g" docker-compose.yml

# Start DVWA
docker-compose up -d

echo "DVWA installed successfully!"
echo "Access DVWA at: http://localhost:$PORT"
echo "Default credentials: admin/password"
echo "Setup database by clicking 'Create/Reset Database' button"
