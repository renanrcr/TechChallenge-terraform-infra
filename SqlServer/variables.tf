variable "environment" {
  description = "The Deployment environment"
}

variable "engine" {
  description = "The database engine"
  type = string
  default = "sqlserver-ex"
}

variable "allocated_storage" {
  description = "The amount of allocated storage."
  type = number
  default = 20
}

variable "storage_type" {
  description = "type of the storage"
  type = string
  default = "gp2"
}

variable "instance_class" {
  description = "The RDS instance class"
  default = "db.t3.micro"
  type = string
}

variable "engine_version" {
  description = "The engine version"
  default = "15.00.4322.2.v1"
  type = string
}

variable "skip_final_snapshot" {
  description = "skip snapshot"
  default = "true"
  type = string
}

variable "identifier" {
  description = "The name of the RDS instance"
  default = "techchallenge"
  type = string
}

variable "port" {
  description = "The port on which the DB accepts connections"
  default = "3306"
  type = number
}

variable "sqlserver-username" {
  description = "Username for the master DB user."
}

variable "sqlserver-password" {
  description = "password of the database"
}

variable "azs" {
  description = "Availability Zones"
}