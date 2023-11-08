variable "environment" {
  description = "The Deployment environment"
}

variable "lb_engress_id" {
  description = "Id of engress"
}

variable "lb_ingress_id" {
  description = "Id of ingress"
}

variable "public_subnets_id" {
  description = "Public subnets"
}

variable "image" {
  description = "Image"
  type = string
  default = "renanrcr/techchallenge:dev"
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

variable "service_name_alb" {
  description = "Service name api"
  type = string
  default = "lanchonete-app-api"
}

variable "arns" {
  description = "List of SecretsManager secret ARNs the task execution role will be permitted to get/read"
}