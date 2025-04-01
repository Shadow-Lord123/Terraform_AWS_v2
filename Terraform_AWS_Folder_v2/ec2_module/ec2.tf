
data "aws_ami" "ubuntu_ami" {
  most_recent = true
  owners      = ["099720109477"] # Canonical (Ubuntu Official AMI Owner ID)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"] # Ubuntu 22.04 LTS
  }
}

resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "example" {
  key_name   = "KeyEC2"
  public_key = tls_private_key.example.public_key_openssh
}

resource "local_file" "private_key" {
  filename        = "${path.module}/KeyEC2.pem"
  content         = tls_private_key.example.private_key_pem
  file_permission = "0600"
}

resource "aws_security_group" "example_sg" {
  name        = "example-sg"
  description = "Allow SSH, HTTP, and HTTPS"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "example" {
  ami                    = data.aws_ami.ubuntu_ami.id
  instance_type          = "t2.micro"
  subnet_id              = var.public_subnet_2_id
  key_name               = var.ssh_key_name
  vpc_security_group_ids = [aws_security_group.example_sg.id]

  root_block_device {
    volume_size           = 20
    volume_type           = "gp3"
    delete_on_termination = true
  }

  user_data = <<-EOF
    #!/bin/bash
    set -euxo pipefail

    exec > /var/log/user-data.log 2>&1

    echo "🚀 Creating setup script at /home/ubuntu/setup_eks.sh..."

    cat <<'EOT' > /home/ubuntu/setup_eks.sh
    #!/bin/bash
    set -euxo pipefail
    exec > /var/log/setup-eks.log 2>&1

    echo "📦 Updating system..."
    sudo apt update -y
    sudo apt upgrade -y

    echo "📦 Installing dependencies..."
    sudo apt install -y unzip curl

    echo "📦 Installing AWS CLI..."
    curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip -q awscliv2.zip
    sudo ./aws/install
    rm -rf aws awscliv2.zip
    /usr/local/bin/aws --version || { echo "❌ AWS CLI installation failed"; exit 1; }

    echo "🔐 Configuring AWS CLI..."
    /usr/local/bin/aws configure set region eu-west-2
    /usr/local/bin/aws configure set output json

    echo "🐳 Installing kubectl..."
    curl -sLO "https://dl.k8s.io/release/$(curl -sL https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    rm -f kubectl
    /usr/local/bin/kubectl version --client || { echo "❌ kubectl installation failed"; exit 1; }

    EKS_CLUSTER_NAME="KritagyaTerraformEKS"
    AWS_REGION="eu-west-2"
    echo "🔧 Configuring kubectl for EKS cluster: $EKS_CLUSTER_NAME in region $AWS_REGION..."
    /usr/local/bin/aws eks --region "$AWS_REGION" update-kubeconfig --name "$EKS_CLUSTER_NAME"

    echo "🛠 Verifying kubectl setup..."
    /usr/local/bin/kubectl get nodes || { echo "❌ Unable to fetch nodes. Check EKS configuration."; exit 1; }

    echo "✅ EKS setup complete!"
    EOT

    sudo chmod +x /home/ubuntu/setup_eks.sh
    sudo chown ubuntu:ubuntu /home/ubuntu/setup_eks.sh

    echo "✅ Script is ready at /home/ubuntu/setup_eks.sh"
  EOF

  tags = {
    Name = "tf-example"
  }
}
