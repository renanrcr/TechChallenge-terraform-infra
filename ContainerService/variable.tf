variable "environment" {
  description = "The Deployment environment"
}

variable "lb_engress_id" {
  description = "Id of engress"
}

variable "lb_ingress_id" {
  description = "Id of ingress"
}

variable "lb_target_group_arn" {
  description = "Target group of the ALB"
}

variable "public_subnets_id" {
  description = "Public subnets"
}

variable "image" {
  description = "Image"
  type = string
  default = "renanrcr/techchallenge:latest"
}

variable "image_name" {
  description = "Image name"
  type = string
  default = "lanchonete-app"
}

variable "service_name" {
  description = "Service name"
  type = string
  default = "lanchonete-app-service"
}