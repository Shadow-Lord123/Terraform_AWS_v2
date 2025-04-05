module "vpc" {
  source = "./vpc_module"
  # Variables
   vpc_cidr             = var.vpc_cidr
  public_subnet_1_cidr  = var.public_subnet_1_cidr
  public_subnet_2_cidr  = var.public_subnet_2_cidr
  private_subnet_1_cidr = var.private_subnet_1_cidr
  private_subnet_2_cidr = var.private_subnet_2_cidr
  availability_zone_1   = var.availability_zone_1
  availability_zone_2   = var.availability_zone_2
  region                = var.region
  ssh_allowed_cidr      = var.ssh_allowed_cidr
}

module "vpc2" {
  source = "./vpc2_module"
  vpc_cidr              = var.vpc_cidr
  vpc_cidr2             = var.vpc_cidr2
  vpc_id                = module.vpc.vpc_id
  vpc2_id               = module.vpc2.vpc2_id      
}

module "ec2" {
  source = "./ec2_module"
  ssh_key_name          = var.ssh_key_name
  vpc_cidr              = module.vpc.vpc_cidr
  vpc_id                = module.vpc.vpc_id
  public_subnet_2_id    = module.vpc.public_subnet_2_id
  public_subnet_2_cidr_block = module.vpc.public_subnet_2_cidr
  aws_access_key             = var.aws_access_key
  aws_secret_key             = var.aws_secret_key         
}

#module "auto_scaling" {
#  source = "./auto-scaling_module"
#  public_subnet_2_id    = module.vpc.public_subnet_2_id
#  public_subnet_1_id    = module.vpc.public_subnet_1_id
#}

module "load-balancer_module" {
  source = "./load-balancer_module"
  public_subnet_2_id    = module.vpc.public_subnet_2_id
  public_subnet_1_id    = module.vpc.public_subnet_1_id
}

module "s3_bucket" {
  source = "./s3_bucket"
}

module "eks" {
  source = "./elastic_kubernetes_service"
  public_subnet_2_id    = module.vpc.public_subnet_2_id
  public_subnet_1_id    = module.vpc.public_subnet_1_id
  private_subnet_1_id   = module.vpc.private_subnet_1_id
  eks_cluster_name      = var.eks_cluster_name
  cluster_role_arn      = module.iam_role.eks_cluster_role_arn
}

module "node_group" {
  source = "./node_group"
  cluster_name       = var.eks_cluster_name
  node_group_name    = var.node_group_name
  node_role_arn      = module.iam_role.eks_node_group_role_arn
  public_subnet_1_id = module.vpc.public_subnet_1_id
  public_subnet_2_id = module.vpc.public_subnet_2_id
}

module "iam_role" {
   source = "./iam" 
   eks_cluster_name   = var.eks_cluster_name
   node_group_name    = var.node_group_name
   aws_account_id     = var.aws_account_id
   admin_user         = var.admin_user 
}

#module "rds_module" {
#  source = "./rds_module"
#  public_subnet_1_id = module.vpc.public_subnet_1_id
#  public_subnet_2_id = module.vpc.public_subnet_2_id
#  replica_vpc_id     = module.rds_module.replica_vpc_id
#  vpc_id                = module.vpc.vpc_id
#}

module "elasticache" {
  source = "./elasticache"
  public_subnet_1_id = module.vpc.public_subnet_1_id
  public_subnet_2_id = module.vpc.public_subnet_2_id
}

module "cloudwatch" {
  source = "./cloudwatch_module"
}

module "route53" {
  source = "./route53_module"
}

module "sns_module" {
  source = "./sns_module"
}

module "document_db" {
  source = "./document_db_module"
  public_subnet_1_id = module.vpc.public_subnet_1_id
  public_subnet_2_id = module.vpc.public_subnet_2_id
  vpc_id             = module.vpc.vpc_id 
}