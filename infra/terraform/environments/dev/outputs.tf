output "rds_identifier" {
  value = aws_db_instance.this.identifier
}

output "rds_endpoint" {
  value = aws_db_instance.this.address
}

output "rds_security_group_id" {
  value = aws_security_group.rds.id
}

output "rds_master_secret_arn" {
  description = "ARN não secreto das credenciais master gerenciadas pelo RDS."
  value       = aws_db_instance.this.master_user_secret[0].secret_arn
}

output "ssm_rds_prefix" {
  value = "/oficina-mecanica/development/rds"
}
