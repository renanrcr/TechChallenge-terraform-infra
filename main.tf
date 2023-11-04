locals {
  azs = ["${var.region}-a", "${var.region}-1b"]
}

module "network-vpc" {
 source = "./Networks"
 environment = var.environment
 azs = local.azs
}

module "database-sqlserver" {
 source = "./SqlServer"
 environment = var.environment
 sqlserver-username = var.sqlserver-username
 sqlserver-password = var.sqlserver-password
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