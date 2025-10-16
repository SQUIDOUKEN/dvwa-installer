# DVWA Windows Installer
param([int]$Port = 4040)

Write-Host "Installing DVWA on Windows..." -ForegroundColor Green

# Check if Docker Desktop is installed
if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Host "Docker not found. Installing Docker Desktop..." -ForegroundColor Yellow
    
    # Download Docker Desktop
    $dockerUrl = "https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe"
    $dockerInstaller = "$env:TEMP\DockerDesktopInstaller.exe"
    
    Invoke-WebRequest -Uri $dockerUrl -OutFile $dockerInstaller
    Start-Process -FilePath $dockerInstaller -Wait
    
    Write-Host "Please restart your computer and run this script again after Docker Desktop is installed." -ForegroundColor Red
    exit
}

# Create DVWA directory
$dvwaPath = "$env:USERPROFILE\dvwa-setup"
New-Item -ItemType Directory -Force -Path $dvwaPath
Set-Location $dvwaPath

# Create docker-compose.yml
$dockerCompose = @"
version: '3.8'
services:
  dvwa:
    image: vulnerables/web-dvwa
    ports:
      - "$Port:80"
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
"@

$dockerCompose | Out-File -FilePath "docker-compose.yml" -Encoding UTF8

# Start DVWA
docker-compose up -d

Write-Host "DVWA installed successfully!" -ForegroundColor Green
Write-Host "Access DVWA at: http://localhost:$Port" -ForegroundColor Cyan
Write-Host "Default credentials: admin/password" -ForegroundColor Yellow
Write-Host "Setup database by clicking 'Create/Reset Database' button" -ForegroundColor Yellow
