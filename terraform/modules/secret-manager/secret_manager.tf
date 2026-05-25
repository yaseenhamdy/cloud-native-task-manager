resource "aws_secretsmanager_secret" "postgres_secret" {
  name = "postgres_secrets"
}