resource "aws_secretsmanager_secret" "secrets" {
  name = "${var.environment}-techchallenge-terraform-terraform"
 tags = {
  Name = "${var.environment}-secrets"
 }
}