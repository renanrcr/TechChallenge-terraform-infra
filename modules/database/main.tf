/*=============RDS=================*/
resource "aws_security_group" "security-group-sqlserver" {
  name        = "security-group-sqlserver"
  description = "Security Group SQLServer"
  vpc_id      = var.vpc_id
  ingress {
    description = "Port"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name        = "Security-group-RDS"
    Environment = "${var.environment}"
  }
}

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