resource "aws_secretsmanager_secret" "mytomorrows" {
  description = "Mytomorrows app sensitive configuration values"
  name        = "mytomorrows-app-sensitive"
}
