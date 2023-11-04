resource "aws_db_instance" "sqlserver_default" {
  allocated_storage = var.allocated_storage
  storage_type = var.storage_type
  engine = var.engine
  engine_version = var.engine_version
  instance_class = var.instance_class
  username = var.sqlserver-username
  password = var.sqlserver-password
  port = var.port
  identifier = var.identifier
  skip_final_snapshot = var.skip_final_snapshot
  availability_zone = var.azs
  tags = {
   Name = "${var.environment}-sqlserver"
 }
}