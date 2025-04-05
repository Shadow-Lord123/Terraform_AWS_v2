
resource "aws_docdb_subnet_group" "default" {
  name       = "public_subnet_group_document_db"
  subnet_ids = [var.public_subnet_1_id, var.public_subnet_2_id]

  tags = {
    Name = "document_db_subnet_group"
  }
}
resource "aws_docdb_cluster_instance" "cluster_instances" {
  count              = 1
  identifier         = "terraform-docdb-cluster-demo-${count.index}"
  cluster_identifier = aws_docdb_cluster.default.id
  instance_class     = "db.t3.medium" 
   tags = {
    Name        = "DocDB Instance"
    Environment = "dev"
  }
}

resource "aws_docdb_cluster" "default" {
  cluster_identifier = "terraform-docdb-cluster-demo"
  availability_zones = ["eu-west-2a", "eu-west-2b"]
  master_username    = "Kritagya"
  master_password    = "MahaPitaji82"
  db_subnet_group_name   = aws_docdb_subnet_group.default.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  skip_final_snapshot     = true
}