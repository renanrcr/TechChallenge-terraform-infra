resource "aws_secretsmanager_secret" "secrets" {
  name = "techchallenge-terraform-fiap"
 tags = {
  Name = "secrets"
 }
}