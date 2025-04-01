
# DB Subnet Group for Aurora RDS
resource "aws_db_subnet_group" "default" {
  name       = "my-db-subnet-group"
  subnet_ids = [var.public_subnet_1_id, var.public_subnet_2_id]

  tags = {
    Name = "My DB Subnet Group"
  }
}

# Aurora Global Cluster
resource "aws_rds_global_cluster" "aurora_global" {
  global_cluster_identifier = "kritagya-global-cluster"
  engine                    = "aurora-mysql"
  engine_version            = "8.0.mysql_aurora.3.04.0"
  storage_encrypted         = true
}

# Primary Aurora Cluster (Read-Write)
resource "aws_rds_cluster" "primary" {
  cluster_identifier          = "kritagya-aurora-primary"
  global_cluster_identifier   = aws_rds_global_cluster.aurora_global.id
  engine                      = "aurora-mysql"
  engine_version              = "8.0.mysql_aurora.3.04.0"
  database_name               = "mydb"
  master_username             = "foo"
  master_password             = "foobarbaz"
  db_subnet_group_name        = aws_db_subnet_group.default.name
  vpc_security_group_ids      = [aws_security_group.rds_sg.id]
  storage_encrypted           = true
  skip_final_snapshot         = true
  deletion_protection         = false
  

  tags = {
    Name = "KritagyaTerraform-PrimaryCluster"
  }
}

# Primary Writer Instance
resource "aws_rds_cluster_instance" "writer" {
  identifier         = "kritagya-writer"
  cluster_identifier = aws_rds_cluster.primary.id
  instance_class     = "db.r5.large"
  engine             = "aurora-mysql"

  tags = {
    Name = "Kritagya-WRITER"
  }
}

# Read-Write Replica
resource "aws_rds_cluster_instance" "readwrite_replica" {
  identifier         = "kritagya-readwrite"
  cluster_identifier = aws_rds_cluster.primary.id
  instance_class     = "db.r5.large"
  engine             = "aurora-mysql"

  tags = {
    Name = "Kritagya-ReadWrite"
  }

  depends_on = [
    aws_rds_cluster.primary
  ]
}

