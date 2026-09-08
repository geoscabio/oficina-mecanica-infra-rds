data "aws_ssm_parameter" "vpc_status" { name = var.vpc_status_parameter_name }
data "aws_ssm_parameter" "vpc_id" { name = "${var.vpc_ssm_prefix}/vpc_id" }
data "aws_ssm_parameter" "private_subnet_ids" { name = "${var.vpc_ssm_prefix}/private_subnet_ids" }
data "aws_ssm_parameter" "private_subnet_cidrs" { name = "${var.vpc_ssm_prefix}/private_subnet_cidrs" }

locals {
  private_subnet_ids   = split(",", data.aws_ssm_parameter.private_subnet_ids.value)
  private_subnet_cidrs = split(",", data.aws_ssm_parameter.private_subnet_cidrs.value)
  common_tags = {
    Project     = "OficinaMecanica"
    Environment = var.environment
    ManagedBy   = "Terraform"
    Repository  = "oficina-mecanica-infra-rds"
  }
}

resource "terraform_data" "vpc_ready" {
  input = data.aws_ssm_parameter.vpc_status.value

  lifecycle {
    precondition {
      condition     = data.aws_ssm_parameter.vpc_status.value == "ready"
      error_message = "A VPC precisa estar pronta no SSM antes do apply do RDS."
    }
  }
}
