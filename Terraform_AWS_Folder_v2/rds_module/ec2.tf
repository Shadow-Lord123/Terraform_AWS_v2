
# AMI for Amazon Linux 2023
data "aws_ami" "ubuntu-ami" {
  most_recent = true
  owners      = ["099720109477"] # Canonical (Ubuntu) Official AMI Owner ID

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"] # Ubuntu 22.04 LTS
  }
}

# Generate private key for EC2
resource "tls_private_key" "rds_instance_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# AWS Key Pair for EC2 instance
resource "aws_key_pair" "rds_instance_key" {
  key_name   = "KritagyaTerraform-aurora-db-credentials"
  public_key = tls_private_key.rds_instance_key.public_key_openssh
}

# Store private key locally
resource "local_file" "private_key" {
  filename        = "${path.module}/KritagyaTerraform-aurora-db-credentials.pem"
  content         = tls_private_key.rds_instance_key.private_key_pem
  file_permission = "0600"
}

resource "aws_instance" "rds_connector" {
  ami                         = data.aws_ami.ubuntu-ami.id
  instance_type               = "t2.micro"
  subnet_id                   = var.public_subnet_1_id
  associate_public_ip_address = true
  security_groups             = [aws_security_group.ec2_sg.id]
  key_name                    = aws_key_pair.rds_instance_key.key_name

  user_data = <<-EOF
    #!/bin/bash -ex
    exec > /var/log/user-data.log 2>&1  # Log output for debugging

    echo "Starting the user-data script execution"

    # 1. List directory contents for debugging
    echo "Listing directory contents"
    ls || { echo "❌ ls command failed"; exit 1; }

    # 2. Update system packages
    echo "Updating system packages..."
    sudo apt update -y || { echo "❌ Apt update failed"; exit 1; }

    # 3. Upgrade system packages
    echo "Upgrading system packages..."
    sudo apt upgrade -y || { echo "❌ Apt upgrade failed"; exit 1; }

    # 4. Install MySQL server
    echo "Installing MySQL server..."
    sudo apt install mysql-server -y || { echo "❌ MySQL installation failed"; exit 1; }

    # 5. Verify MySQL installation
    echo "Verifying MySQL server installation..."
    mysql-server --version || { echo "❌ MySQL server installation failed"; exit 1; }

    # 6. Verify MySQL client installation
    echo "Verifying MySQL client installation..."
    mysql --version || { echo "❌ MySQL client installation failed"; exit 1; }

    # 7. Hardcoded database credentials
    RDS_ENDPOINT="kritagya-global-cluster.global-gz98qn0nnotx.global.rds.amazonaws.com"
    DB_NAME="mydb"
    DB_USER="foo"
    DB_PASS="foobarbaz"

    # 8. Create MySQL connection script and save it to a file
    echo "Creating MySQL connection script"
    cat <<EOT > /home/ubuntu/connect_db.sh
    #!/bin/bash
    mysql -h "\$RDS_ENDPOINT" -u "\$DB_USER" -p"\$DB_PASS" "\$DB_NAME"
    EOT

    # 9. Make the script executable
    chmod +x /home/ubuntu/connect_db.sh || { echo "❌ Failed to make connect_db.sh executable"; exit 1; }

    # 10. Display final message
    echo "✅ Setup complete! Run the following to connect:"
    echo "bash /home/ubuntu/connect_db.sh"

    # 11. Show the history of commands
    history
  EOF

  tags = {
    Name = "rds_connector"
  }
}
