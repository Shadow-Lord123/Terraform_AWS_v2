

resource "aws_iam_role" "eks_role" {
  name = "eks-cluster-role2"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "eks.amazonaws.com" }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "eks_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_role.name
}

resource "aws_eks_cluster" "eks" {
  name     = "my-eks-cluster"
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids = [var.public_subnet_1_id, var.public_subnet_2_id] # Replace with your subnet IDs
  }
}

resource "aws_iam_role" "node_group_role" {
  name = "eks-node-group-role2"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "node_group_policy" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  ])
  role       = aws_iam_role.node_group_role.name
  policy_arn = each.value
}

resource "aws_eks_node_group" "node_group" {
  cluster_name  = aws_eks_cluster.eks.name
  node_group_name = "eks-node-group"
  node_role_arn = aws_iam_role.node_group_role.arn
  subnet_ids    = [var.public_subnet_1_id, var.public_subnet_2_id] # Replace with your subnet IDs
  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  instance_types = ["t3.medium"]
}

resource "aws_iam_role" "fargate_pod_execution_role" {
  name = "fargate-pod-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "eks-fargate-pods.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "fargate_pod_execution_role_policy" {
  role       = aws_iam_role.fargate_pod_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
}

