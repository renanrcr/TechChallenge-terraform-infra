output "db_instance_name" {
  description = "The database name Outputs"
  value = try(aws_db_instance.sqlserver_default.db_name, null)
}

output "db_instance_address" {
  description = "Address instance Outputs"
  value = try(aws_db_instance.sqlserver_default.address, null)
}

output "db_instance_port" {
  description = "Database port Outputs"
  value = try(aws_db_instance.sqlserver_default.port, null)
}

output "db_instance_availability_zone" {
  description = "Availability zone instance Outputs"
  value = try(aws_db_instance.sqlserver_default.availability_zone, null)
}

output "db_instance_engine" {
  description = "Instance Engine Outputs"
  value = try(aws_db_instance.sqlserver_default.engine, null)
}