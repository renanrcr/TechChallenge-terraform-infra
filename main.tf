module "network-vpc" {
 source = "./Networks"
 environment = var.environment
 azs = var.azs
}

module "database-sqlserver" {
 source = "./SqlServer"
 environment = var.environment
 sqlserver-username = var.sqlserver-username
 sqlserver-password = var.sqlserver-password
}

module "bucket-s3" {
  source = "./Bucket-S3"
  environment = var.environment
}

module "secrets" {
  source = "./Secrets"
  environment = var.environment
}