
resource "aws_eks_cluster" "example" {
  name = var.eks_cluster_name
  role_arn = var.cluster_role_arn
  version  = "1.31"

  vpc_config {
    subnet_ids = [
      var.public_subnet_1_id,
      var.public_subnet_2_id,
      var.private_subnet_1_id
    ]
  }

  depends_on = [var.cluster_role_arn]
}
