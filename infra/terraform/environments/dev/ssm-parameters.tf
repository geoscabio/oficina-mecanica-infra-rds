resource "aws_ssm_parameter" "endpoint" {
  name        = "/oficina-mecanica/development/rds/endpoint"
  description = "Endpoint SQL Server RDS usado por esteiras dependentes."
  type        = "String"
  value       = aws_db_instance.this.address
  tags        = local.common_tags
}
resource "aws_ssm_parameter" "security_group_id" {
  name        = "/oficina-mecanica/development/rds/security_group_id"
  description = "Security group do RDS usado por esteiras dependentes."
  type        = "String"
  value       = aws_security_group.rds.id
  tags        = local.common_tags
}
resource "aws_ssm_parameter" "status" {
  name        = "/oficina-mecanica/development/status/rds"
  description = "Status operacional da infraestrutura RDS compartilhada."
  type        = "String"
  value       = "ready"
  tags        = local.common_tags
}
