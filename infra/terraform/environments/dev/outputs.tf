output "rds_identifier" {
  value = aws_db_instance.this.identifier
}

output "rds_endpoint" {
  value = aws_db_instance.this.address
}

output "rds_security_group_id" {
  value = aws_security_group.rds.id
}

output "ssm_rds_prefix" {
  value = "/oficina-mecanica/development/rds"
}
