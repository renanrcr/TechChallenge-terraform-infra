resource "aws_db_instance" "sqlserver_default" {
  allocated_storage = var.allocated_storage
  storage_type = var.storage_type
  engine = var.engine
  engine_version = var.engine_version
  instance_class = var.instance_class
  username = var.sqlserver_username
  password = var.sqlserver_password
  port = var.port
  identifier = var.identifier
  skip_final_snapshot = var.skip_final_snapshot
  availability_zone = var.azs[0]
  tags = {
   Name = "${var.environment}-sqlserver"
 }
}

resource "aws_dynamodb_table" "customer_db" {
  name = "customers_cache"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "userId"
  stream_enabled = false
  table_class = "STANDARD"
  deletion_protection_enabled = false
  ttl {
    enabled = true
    attribute_name = "ttl"
  }
  attribute {
    name = "userId"
    type = "S"
  }
  server_side_encryption {
    enabled = true
  }
  tags = {
    Name = "DynamoDB"
  }
}