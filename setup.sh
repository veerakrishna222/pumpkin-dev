#!/bin/bash

# Update system
sudo apt update -y
sudo apt upgrade -y

echo "===================================="
echo "Installing Docker on Ubuntu 24.04..."
echo "===================================="

# Remove old conflicting versions
sudo apt remove -y containerd containerd.io docker docker.io docker-engine docker-compose-plugin

# Install dependencies
sudo apt install -y ca-certificates curl gnupg

# Add Docker GPG key
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add Docker repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu noble stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update and install Docker
sudo apt update -y
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Start Docker
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker ubuntu

echo "=============================="
echo "Installing AWS CLI v2..."
echo "=============================="

# Install AWS CLI v2 (Ubuntu 24.04 compatible)
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt install unzip -y
unzip awscliv2.zip
sudo ./aws/install
rm -rf aws awscliv2.zip

echo "=============================="
echo "Creating deploy script..."
echo "=============================="

# Deploy Script
cat << 'EOF' > /usr/local/bin/deploy-app.sh
#!/bin/bash

ECR_URL="084828575514.dkr.ecr.ap-south-1.amazonaws.com/nextjs-app-1"
IMAGE="$ECR_URL:latest"

aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin $ECR_URL
docker pull $IMAGE

docker stop app_container || true
docker rm app_container || true

docker run -d -p 80:3000 --name app_container $IMAGE
EOF

chmod +x /usr/local/bin/deploy-app.sh

echo "===================================="
echo "Setup Completed Successfully!"
echo "===================================="

