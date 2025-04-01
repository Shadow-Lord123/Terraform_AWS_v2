
# VPC for Read Replica in us-east-2
resource "aws_vpc" "replica_vpc" {
  provider   = aws.us-east-2
  cidr_block = "10.1.0.0/16"

  tags = {
    Name = "Replica VPC"
  }
}

# Private Route Table for the Replica VPC
resource "aws_route_table" "replica_private_rt" {
  provider = aws.us-east-2
  vpc_id   = aws_vpc.replica_vpc.id

  tags = {
    Name = "Replica Private Route Table"
  }
}

# Subnets for Read Replica in us-east-2
resource "aws_subnet" "replica_subnet_1" {
  provider          = aws.us-east-2
  vpc_id            = aws_vpc.replica_vpc.id
  cidr_block        = "10.1.1.0/24"
  availability_zone = "us-east-2a"

  tags = {
    Name = "Replica Subnet 1"
  }
}

resource "aws_subnet" "replica_subnet_2" {
  provider          = aws.us-east-2
  vpc_id            = aws_vpc.replica_vpc.id
  cidr_block        = "10.1.2.0/24"
  availability_zone = "us-east-2b"

  tags = {
    Name = "Replica Subnet 2"
  }
}

# Associate Subnets with the Private Route Table
resource "aws_route_table_association" "replica_subnet_1_assoc" {
  provider       = aws.us-east-2
  subnet_id      = aws_subnet.replica_subnet_1.id
  route_table_id = aws_route_table.replica_private_rt.id
}

resource "aws_route_table_association" "replica_subnet_2_assoc" {
  provider       = aws.us-east-2
  subnet_id      = aws_subnet.replica_subnet_2.id
  route_table_id = aws_route_table.replica_private_rt.id
}

# Subnet Group for Read Replica in us-east-2
resource "aws_db_subnet_group" "replica" {
  provider   = aws.us-east-2
  name       = "my-db-subnet-group-replica"
  subnet_ids = [aws_subnet.replica_subnet_1.id, aws_subnet.replica_subnet_2.id]

  tags = {
    Name = "My DB Subnet Group Replica"
  }
}

# KMS key for RDS cluster encryption
resource "aws_kms_key" "replica_encryption_key" {
  provider                = aws.us-east-2
  description             = "KMS key for RDS cluster encryption in us-east-2"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

# Secondary Aurora Cluster (Read-Only) in us-east-2
resource "aws_rds_cluster" "replica" {
  provider                  = aws.us-east-2
  cluster_identifier        = "kritagya-aurora-replica" 
  global_cluster_identifier = aws_rds_global_cluster.aurora_global.id
  engine                    = "aurora-mysql"
  engine_version            = "8.0.mysql_aurora.3.04.0"
  db_subnet_group_name      = aws_db_subnet_group.replica.name
  storage_encrypted         = true
  kms_key_id                = aws_kms_key.replica_encryption_key.arn
  skip_final_snapshot       = true
  deletion_protection       = false

  tags = {
    Name = "KritagyaTerraform-Replica"
  }

  depends_on = [
    aws_db_subnet_group.replica,
    aws_kms_key.replica_encryption_key
  ]
}

# Read Replica Instance in us-east-2
resource "aws_rds_cluster_instance" "replica_instance" {
  provider           = aws.us-east-2
  identifier         = "kritagya-replica-instance"
  cluster_identifier = aws_rds_cluster.replica.id
  instance_class     = "db.r5.large"
  engine             = "aurora-mysql"

  tags = {
    Name = "Kritagya-REPLICA"
  }

  depends_on = [
    aws_rds_cluster.replica
  ]
}
