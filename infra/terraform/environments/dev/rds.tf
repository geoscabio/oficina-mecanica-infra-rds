resource "aws_db_subnet_group" "this" {
  name       = "${var.db_name}-subnets"
  subnet_ids = local.private_subnet_ids
  tags       = local.common_tags
}

resource "aws_security_group" "rds" {
  name        = "${var.db_name}-sg"
  description = "Acesso ao RDS da Oficina Mecanica"
  vpc_id      = data.aws_ssm_parameter.vpc_id.value
  tags        = local.common_tags

}

resource "aws_vpc_security_group_ingress_rule" "eks_sql_server" {
  description                  = "SQL Server somente a partir do security group do cluster EKS"
  security_group_id            = aws_security_group.rds.id
  referenced_security_group_id = data.aws_ssm_parameter.kubernetes_cluster_security_group_id.value
  ip_protocol                  = "tcp"
  from_port                    = 1433
  to_port                      = 1433

  depends_on = [terraform_data.kubernetes_ready]
}

resource "aws_db_instance" "this" {
  identifier                  = var.db_name
  engine                      = "sqlserver-ex"
  engine_version              = var.db_engine_version
  instance_class              = var.db_instance_class
  allocated_storage           = var.db_allocated_storage
  backup_retention_period     = 0
  storage_encrypted           = true
  username                    = var.db_username
  manage_master_user_password = true
  port                        = 1433
  db_subnet_group_name        = aws_db_subnet_group.this.name
  vpc_security_group_ids      = [aws_security_group.rds.id]
  publicly_accessible         = false
  skip_final_snapshot         = true
  deletion_protection         = false
  tags                        = local.common_tags
  depends_on = [
    terraform_data.vpc_ready,
    terraform_data.kubernetes_ready,
  ]
}
