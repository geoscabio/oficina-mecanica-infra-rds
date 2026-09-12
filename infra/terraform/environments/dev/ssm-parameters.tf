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
resource "aws_ssm_parameter" "master_secret_arn" {
  name        = "/oficina-mecanica/development/rds/master_secret_arn"
  description = "ARN não secreto das credenciais master gerenciadas pelo RDS no Secrets Manager."
  type        = "String"
  value       = aws_db_instance.this.master_user_secret[0].secret_arn
  tags        = local.common_tags
}
resource "aws_ssm_parameter" "status" {
  # Publicar ready somente após concluir a infraestrutura e seus contratos SSM.
  depends_on = [
    aws_db_instance.this,
    aws_ssm_parameter.endpoint,
    aws_ssm_parameter.security_group_id,
    aws_ssm_parameter.master_secret_arn,
  ]

  name        = "/oficina-mecanica/development/status/rds"
  description = "Status operacional da infraestrutura RDS compartilhada."
  type        = "String"
  value       = "ready"
  tags        = local.common_tags
}
