# These values will be used for vault later
output "db_username_secret" {
  value = var.db_username
}

output "db_password_secret" {
    value = var.db_password_plain
}