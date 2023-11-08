variable "vpc_cidr" {
  description = "cidr"
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  default = ["10.0.0.0/20", "10.0.16.0/20"]
  description = "The ID of the subnet Outputs"
}

variable "private_subnet_cidrs" {
  default = ["10.0.128.0/20", "10.0.144.0/20"]
  description = "The ID of the subnet Outputs"
}

variable "availability_zones" {
  description = "availability zone para as subnets"
}