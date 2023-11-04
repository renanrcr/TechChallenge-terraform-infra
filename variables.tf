variable "region" {
  description = "us-east-1"
  type = string
}

variable "environment" {
  description = "The Deployment environment"
  type = string
}

variable "access_key" {
  description = "AWS access key to create resources"
}

variable "secret_key" {
  description = "AWS secret key to create resources"
}

variable "sqlserver-username" {
  description = "Username for the master DB user."
  type = string
}

variable "sqlserver-password" {
  description = "password of the database"
  type = string
}