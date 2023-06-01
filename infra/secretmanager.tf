resource "aws_secretsmanager_secret" "ecsbackend" {
  name = join("-", ["secret-backend", "dev006"])
}


resource "aws_secretsmanager_secret_version" "ecsbackend" {
  secret_id = aws_secretsmanager_secret.ecsbackend.id
  secret_string = jsonencode({
    USER_DATABASE             = var.database_username
    PASSWORD_DATABASE              = var.database_password
  
    
  })
}
