resource "aws_secretsmanager_secret" "mysql" {
  name = "project-bedrock/mysql"
}

resource "aws_secretsmanager_secret_version" "mysql" {
  secret_id = aws_secretsmanager_secret.mysql.id
  secret_string = jsonencode({
    username = "admin"
    password = random_password.mysql.result
    host     = aws_db_instance.mysql.address
    port     = 3306
    dbname   = "catalog"
  })
}

resource "aws_secretsmanager_secret" "postgresql" {
  name = "project-bedrock/postgresql"
}

resource "aws_secretsmanager_secret_version" "postgresql" {
  secret_id = aws_secretsmanager_secret.postgresql.id
  secret_string = jsonencode({
    username = "dbadmin"
    password = random_password.postgresql.result
    host     = aws_db_instance.postgresql.address
    port     = 5432
    dbname   = "orders"
  })
}