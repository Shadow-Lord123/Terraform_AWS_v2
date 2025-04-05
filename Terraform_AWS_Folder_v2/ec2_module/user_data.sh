
#!/bin/bash
set -euxo pipefail

exec > >(tee /var/log/user-data.log) 2>&1

echo "🚀 Creating setup script at /home/ubuntu/setup_eks.sh..."

cat <<'EOT' > /home/ubuntu/setup_eks.sh
#!/bin/bash
set -euxo pipefail
exec > >(tee /var/log/setup-eks.log) 2>&1

echo "📦 Updating system packages..."
sudo apt update -y && sudo apt upgrade -y

echo "📦 Installing dependencies..."
sudo apt install -y unzip curl jq

echo "📦 Installing AWS CLI..."
curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -q awscliv2.zip
sudo ./aws/install
rm -rf aws awscliv2.zip
if ! /usr/local/bin/aws --version; then
    echo "❌ AWS CLI installation failed!" && exit 1
fi

echo "🔐 Configuring AWS CLI..."
mkdir -p ~/.aws
cat <<EOF2 > ~/.aws/credentials
[default]
aws_access_key_id = ${AWS_ACCESS_KEY}
aws_secret_access_key = ${AWS_SECRET_KEY}
region = ${AWS_REGION}
output = json
EOF2

chmod 600 ~/.aws/credentials

echo "🐳 Installing kubectl..."
KUBE_VERSION=$(curl -sL https://dl.k8s.io/release/stable.txt)
curl -sLO "https://dl.k8s.io/release/$KUBE_VERSION/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm -f kubectl
if ! /usr/local/bin/kubectl version --client; then
    echo "❌ kubectl installation failed!" && exit 1
fi

echo "🔧 Configuring kubectl for EKS cluster: ${EKS_CLUSTER_NAME} in region ${AWS_REGION}..."
/usr/local/bin/aws eks update-kubeconfig --region "${AWS_REGION}" --name "${EKS_CLUSTER_NAME}"

echo "🛠 Verifying kubectl setup..."
if ! /usr/local/bin/kubectl get nodes; then
    echo "❌ Unable to fetch nodes. Check EKS configuration." && exit 1
fi

echo "✅ EKS setup complete!"
EOT

sudo chmod +x /home/ubuntu/setup_eks.sh
sudo chown ubuntu:ubuntu /home/ubuntu/setup_eks.sh

echo "✅ Script is ready at /home/ubuntu/setup_eks.sh"
