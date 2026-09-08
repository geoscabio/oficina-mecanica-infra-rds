variable "aws_region" {
  type    = string
  default = "us-east-1"
}
variable "environment" {
  type    = string
  default = "development"
}
variable "db_name" {
  type    = string
  default = "oficina-mecanica-rds-dev"
}
variable "db_instance_class" {
  type    = string
  default = "db.t3.micro"
}
variable "db_allocated_storage" {
  type    = number
  default = 20
}
variable "db_engine_version" {
  type    = string
  default = "15.00.4420.2.v1"
}
variable "db_username" {
  type      = string
  sensitive = true
}
variable "db_password" {
  type      = string
  sensitive = true
}
variable "vpc_ssm_prefix" {
  type    = string
  default = "/oficina-mecanica/development/vpc"
}
variable "vpc_status_parameter_name" {
  type    = string
  default = "/oficina-mecanica/development/status/vpc"
}
