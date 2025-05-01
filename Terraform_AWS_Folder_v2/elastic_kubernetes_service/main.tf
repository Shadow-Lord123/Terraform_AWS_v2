
resource "aws_eks_cluster" "example" {
  name      = var.eks_cluster_name
  role_arn  = var.cluster_role_arn
  version   = "1.31"

  vpc_config {
    subnet_ids = [
      var.public_subnet_1_id,
      var.public_subnet_2_id,
      var.private_subnet_1_id
    ]
  }

  depends_on = [var.cluster_role_arn]
}

resource "aws_eks_fargate_profile" "default" {
  cluster_name           = aws_eks_cluster.example.name
  fargate_profile_name   = "terraform-fargate-profile"
  pod_execution_role_arn = aws_iam_role.fargate_pod_execution_role.arn
  subnet_ids             = [
    var.private_subnet_1_id,
    var.private_subnet_2_id
  ]

  selector {
    namespace = "default"
  }

  depends_on = [aws_eks_cluster.example]
}
