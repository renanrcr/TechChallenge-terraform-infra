locals {
  dev_availability_zones = ["${var.region}a", "${var.region}b"]
}

module "networkVPC" {
  source = "./modules/networks"

  availability_zones = local.dev_availability_zones
}

module "databases" {
  source = "./modules/database"

  environment = var.environment
  vpc_id = module.networkVPC.vpc_id   
  sqlserver_username = var.sqlserver_username
  sqlserver_password = var.sqlserver_password
  azs = local.dev_availability_zones
}

module "bucketS3" {
  source = "./modules/bucket-s3"

  environment = var.environment
}

module "secrets" {
  source = "./modules/secrets"
}

module "loadBalancer" {
  source = "./modules/loadBalancer"

  vpc = module.networkVPC.vpc_id
  public_subnets_id = module.networkVPC.public_subnet_id
}

module "ecs" {
  source = "./modules/containerService"

  environment = var.environment
  public_subnets_id = module.networkVPC.public_subnet_id
  lb_engress_id = module.loadBalancer.egress_all_id
  lb_ingress_id = module.loadBalancer.ingress_api_id
  arns = module.loadBalancer.lb_target_group_arn
}
