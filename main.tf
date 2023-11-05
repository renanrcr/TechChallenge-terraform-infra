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

module "load-balancer" {
  source = "./LoadBalancer"
  environment = var.environment
  vpc = module.network-vpc.vpc_id
  public_subnets_id = module.network-vpc.public_subnet_id
}

module "container-service" {
  source = "./ContainerService"
  environment = var.environment
  public_subnets_id = module.network-vpc.public_subnet_id
  lb_engress_id = module.network-vpc.vpc_id
  lb_ingress_id = module.network-vpc.vpc_id
  lb_target_group_arn = module.load-balancer.lb_target_group_arn
}

module "secrets" {
  source = "./Secrets"
  environment = var.environment
}