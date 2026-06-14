output "writer_endpoint" {
  value = aws_rds_cluster.aurora.endpoint
}

output "database_name" {
  value = aws_rds_cluster.aurora.database_name
}

output "username" {
  value = aws_rds_cluster.aurora.master_username
}

output "password" {
  value     = random_password.db_password.result
  sensitive = true
}