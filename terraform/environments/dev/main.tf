locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

module "vpc" {
  source = "../../modules/vpc"

  name_prefix        = local.name_prefix
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  database_subnets   = var.database_subnets
}

module "ecr" {
  source = "../../modules/ecr"

  name_prefix = local.name_prefix
}

module "eks" {
  source = "../../modules/eks"

  name_prefix        = local.name_prefix
  cluster_version    = var.eks_cluster_version
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids

  node_instance_type = var.node_instance_type
  node_desired_size  = var.node_desired_size
  node_min_size      = var.node_min_size
  node_max_size      = var.node_max_size
}

module "security" {
  source = "../../modules/security"

  name_prefix                = local.name_prefix
  vpc_id                     = module.vpc.vpc_id
  eks_node_security_group_id = module.eks.node_security_group_id
}

module "rds_aurora" {
  source = "../../modules/rds-aurora"

  name_prefix           = local.name_prefix
  database_subnet_ids   = module.vpc.database_subnet_ids
  rds_security_group_id = module.security.rds_security_group_id

  db_name           = var.db_name
  db_username       = var.db_username
  db_instance_class = var.db_instance_class
}

module "iam" {
  source = "../../modules/iam"

  name_prefix = local.name_prefix
}