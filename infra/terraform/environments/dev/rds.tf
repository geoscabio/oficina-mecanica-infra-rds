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

  ingress {
    description = "SQL Server somente pela rede privada da VPC"
    from_port   = 1433
    to_port     = 1433
    protocol    = "tcp"
    cidr_blocks = local.private_subnet_cidrs
  }
}

resource "aws_db_instance" "this" {
  identifier              = var.db_name
  engine                  = "sqlserver-ex"
  engine_version          = var.db_engine_version
  instance_class          = var.db_instance_class
  allocated_storage       = var.db_allocated_storage
  backup_retention_period = 0
  storage_encrypted       = true
  username                = var.db_username
  password                = var.db_password
  port                    = 1433
  db_subnet_group_name    = aws_db_subnet_group.this.name
  vpc_security_group_ids  = [aws_security_group.rds.id]
  publicly_accessible     = false
  skip_final_snapshot     = true
  deletion_protection     = false
  tags                    = local.common_tags
  depends_on              = [terraform_data.vpc_ready]
}
