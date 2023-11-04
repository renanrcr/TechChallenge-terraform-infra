output "aws_secretsmanager_secret_arn" {
  description = "Secrets Outputs"
  value = aws_secretsmanager_secret.secrets.arn
}