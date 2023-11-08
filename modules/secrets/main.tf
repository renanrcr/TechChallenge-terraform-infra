resource "aws_secretsmanager_secret" "secrets" {
  name = "techchallenge-terraform-terraform"
 tags = {
  Name = "secrets"
 }
}