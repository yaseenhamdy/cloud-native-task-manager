resource "aws_secretsmanager_secret" "postgres_secret" {
  name = "postgres_secrets"
  recovery_window_in_days = 0
}