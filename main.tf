locals {
  azs = ["${var.region}a", "${var.region}b"]
}

module "network-vpc" {
 source = "./Networks"
 environment = var.environment
 azs = local.azs
}

module "database-sqlserver" {
 source = "./SqlServer"
 environment = var.environment
 sqlserver_username = var.sqlserver_username
 sqlserver_password = var.sqlserver_password
 azs = local.azs
}

module "bucket-s3" {
  source = "./Bucket-S3"
  environment = var.environment
}

module "secrets" {
  source = "./Secrets"
  environment = var.environment
}