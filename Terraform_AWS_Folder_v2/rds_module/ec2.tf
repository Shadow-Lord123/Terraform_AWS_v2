
resource "aws_instance" "rds_connector" {
  ami                         = data.aws_ami.ubuntu-ami.id
  instance_type               = "t2.micro"
  subnet_id                   = var.public_subnet_1_id
  associate_public_ip_address = true
  security_groups             = [aws_security_group.ec2_sg.id]
  key_name                    = aws_key_pair.rds_instance_key.key_name

  user_data = <<-EOF
    #!/bin/bash -ex
    exec > /var/log/user-data.log 2>&1  # Capture all logs

    echo "🚀 Starting EC2 setup script execution..."

    # Update and upgrade system packages
    echo "📦 Updating system..."
    sudo apt update -y && sudo apt upgrade -y || { echo "❌ System update failed"; exit 1; }

    # Install MySQL client
    echo "🐬 Installing MySQL client..."
    sudo apt install mysql-client -y || { echo "❌ MySQL client installation failed"; exit 1; }

    # Database credentials
    RDS_ENDPOINT="kritagya-aurora-primary.cluster-canauy4hzzx2.eu-west-2.rds.amazonaws.com"
    DB_NAME="mydb"
    DB_USER="foo"
    DB_PASS="foobarbaz"

    # Create MySQL connection script
    echo "📝 Creating MySQL connection script at /home/ubuntu/connect_db.sh"
    cat <<EOT > /home/ubuntu/connect_db.sh
    #!/bin/bash
    mysql -h "$RDS_ENDPOINT" -u "$DB_USER" -p"$DB_PASS" "$DB_NAME"
    EOT

    # Set proper permissions
    sudo chmod +x /home/ubuntu/connect_db.sh
    sudo chown ubuntu:ubuntu /home/ubuntu/connect_db.sh

    # Verify script exists
    if [[ -f "/home/ubuntu/connect_db.sh" ]]; then
        echo "✅ MySQL connection script successfully created!"
    else
        echo "❌ MySQL connection script missing!" && exit 1
    fi

    # Display final message
    echo "🚀 Setup complete! Run the following to connect to the DB:"
    echo "bash /home/ubuntu/connect_db.sh"
  EOF

  tags = {
    Name = "rds_connector"
  }
}
