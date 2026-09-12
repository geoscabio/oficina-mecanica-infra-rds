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
  default = "oficina-mecanica-db-dev"
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
  default = "16.00.4185.3.v1"
}
variable "db_username" {
  type = string
}
variable "vpc_ssm_prefix" {
  type    = string
  default = "/oficina-mecanica/development/vpc"
}
variable "vpc_status_parameter_name" {
  type    = string
  default = "/oficina-mecanica/development/status/vpc"
}
variable "kubernetes_ssm_prefix" {
  type    = string
  default = "/oficina-mecanica/development/kubernetes"
}
variable "kubernetes_status_parameter_name" {
  type    = string
  default = "/oficina-mecanica/development/status/kubernetes"
}
