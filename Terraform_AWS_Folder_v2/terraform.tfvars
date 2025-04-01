
# Terraform Variables

vpc_cidr              = "10.123.0.0/16"
vpc_cidr2             = "192.168.0.0/16"
public_subnet_1_cidr  = "10.123.1.0/24"
public_subnet_2_cidr  = "10.123.2.0/24"
private_subnet_1_cidr = "10.123.3.0/24"
private_subnet_2_cidr = "10.123.4.0/24"
availability_zone_1   = "eu-west-2a"
availability_zone_2   = "eu-west-2b"
region                = "eu-west-2"
ssh_allowed_cidr      = "0.0.0.0/0"  # Change to a specific IP for security
ssh_key_name          = "KeyEC2"
eks_cluster_name      = "KritagyaTerraformEKS"
node_group_name       = "KritagyaNodeGroup"
aws_account_id        = "123456789012"
admin_user            = "your-iam-username"


