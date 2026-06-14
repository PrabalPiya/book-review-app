output "vpc_id" {
  value = module.vpc.vpc_id
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "frontend_ecr_repository_url" {
  value = module.ecr.frontend_repository_url
}

output "backend_ecr_repository_url" {
  value = module.ecr.backend_repository_url
}

output "aurora_writer_endpoint" {
  value = module.rds_aurora.writer_endpoint
}

output "aurora_database_name" {
  value = module.rds_aurora.database_name
}

output "aurora_username" {
  value     = module.rds_aurora.username
  sensitive = true
}

output "aurora_password" {
  value     = module.rds_aurora.password
  sensitive = true
}

output "azure_devops_policy_arn" {
  value = module.iam.azure_devops_policy_arn
}