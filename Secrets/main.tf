resource "aws_secretsmanager_secret" "secrets" {
  name = "${var.environment}-techchallenge-terraform"
 tags = {
  Name = "${var.environment}-secrets"
 }
}