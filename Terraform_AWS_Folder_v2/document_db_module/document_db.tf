
resource "aws_docdb_cluster_instance" "cluster_instances" {
  count              = 1
  identifier         = "docdb-cluster-demo-${count.index}"
  cluster_identifier = aws_docdb_cluster.default.id
  instance_class     = "db.t3.medium"
}

resource "aws_docdb_cluster" "default" {
  cluster_identifier = "docdb-cluster-demo"
  availability_zones = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
  master_username    = "Kritagya"
  master_password    = "MahaPitaji82"
}