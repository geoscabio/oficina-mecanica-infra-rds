resource "aws_ssm_parameter" "endpoint" {
  name  = "/oficina-mecanica/development/rds/endpoint"
  type  = "String"
  value = aws_db_instance.this.address
}
resource "aws_ssm_parameter" "security_group_id" {
  name  = "/oficina-mecanica/development/rds/security_group_id"
  type  = "String"
  value = aws_security_group.rds.id
}
resource "aws_ssm_parameter" "status" {
  name  = "/oficina-mecanica/development/status/rds"
  type  = "String"
  value = "ready"
}
