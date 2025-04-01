
resource "aws_eks_node_group" "example" {
  cluster_name    = var.cluster_name
  node_group_name = var.node_group_name
  node_role_arn   = var.node_role_arn
  subnet_ids      = [var.public_subnet_1_id, var.public_subnet_2_id]

  capacity_type  = "ON_DEMAND"
  instance_types = ["t2.micro"]

  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 2
  }


  depends_on = [var.node_role_arn]
}




