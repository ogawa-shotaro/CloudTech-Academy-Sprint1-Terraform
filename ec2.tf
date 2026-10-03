data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "sprint1_terra_api_server" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.sprint1_terra_private_subnet.id
  vpc_security_group_ids = [aws_security_group.sprint1_terra_api_sg.id]

  user_data = <<-EOF
#!/bin/bash
set -e

#############################################
# Configuration
#############################################
GITHUB_REPO="https://github.com/CloudTechOrg/sprint1-api.git"  # GitHubリポジトリのURLを設定してください
GITHUB_BRANCH="main"
#############################################

# Update system
dnf update -y

# Install Go and Git
dnf install -y golang git

# Set Go environment variables
export HOME=/root
export GOPATH=/root/go
export GOMODCACHE=/root/go/pkg/mod
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin

# Create app directory
mkdir -p /opt/api
cd /opt/api

# Clone repository from GitHub
git clone -b $GITHUB_BRANCH $GITHUB_REPO .
rm -rf .git

# Download dependencies
go mod tidy

# Build the application
go build -o bmi-api main.go

# Create systemd service
cat > /etc/systemd/system/bmi-api.service << SERVICEEOF
[Unit]
Description=BMI API Server
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/opt/api
ExecStart=/opt/api/bmi-api
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
SERVICEEOF

# Enable and start service
systemctl daemon-reload
systemctl enable bmi-api
systemctl start bmi-api
EOF

  tags = {
    Name = "sprint1_api_server"
  }
}

resource "aws_instance" "sprint1_terra_web_server" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.sprint1_terra_public_subnet.id
  vpc_security_group_ids = [aws_security_group.sprint1_terra_web_sg.id]

  user_data = <<-EOF
#!/bin/bash
set -e

#############################################
# Configuration
#############################################
API_SERVER_IP="${aws_instance.sprint1_terra_api_server.private_ip}" # APIサーバのPrivateIPを設定してください
GITHUB_REPO="https://github.com/CloudTechOrg/sprint1-frontend.git"
GITHUB_BRANCH="main"
#############################################

# Update system
dnf update -y

# Install nginx and git
dnf install -y nginx git

# Start and enable nginx
systemctl start nginx
systemctl enable nginx

# Clone repository from GitHub (files at root level)
cd /tmp
git clone -b $GITHUB_BRANCH $GITHUB_REPO repo

# Copy frontend files to nginx directory
cp -r repo/* /usr/share/nginx/html/
rm -rf repo

# Update config.js to use relative path (via reverse proxy)
cat > /usr/share/nginx/html/config.js << 'CONFIGEOF'
const CONFIG = {
    API_BASE_URL: '/api'
};
CONFIGEOF

# Configure nginx with reverse proxy for API
cat > /etc/nginx/conf.d/default.conf << NGINXEOF
server {
    listen 80;
    server_name _;

    # Serve static frontend files
    location / {
        root /usr/share/nginx/html;
        index index.html;
        try_files \$uri \$uri/ /index.html;
    }

    # Reverse proxy for API requests
    location /api/ {
        proxy_pass http://$API_SERVER_IP:8080/api/;
        proxy_http_version 1.1;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
NGINXEOF

# Set permissions
chown -R nginx:nginx /usr/share/nginx/html
chmod -R 755 /usr/share/nginx/html

# Restart nginx to apply proxy config
systemctl restart nginx
EOF

  tags = {
    Name = "sprint1_web_server"
  }
}

resource "aws_eip" "sprint1_terra_web_eip" {
  domain     = "vpc"
  instance   = aws_instance.sprint1_terra_web_server.id
  depends_on = [aws_internet_gateway.sprint1_terra_igw]

  tags = {
    Name = "sprint1_web_eip"
  }
}
