resource "random_integer" "suffix" {
  min = 10000
  max = 99999
}

# AWS Secrets Manager for Database Credentials (Multi-Region)
resource "aws_secretsmanager_secret" "db_credentials" {
  name = "KritagyaTerraform-aurora-db-credentials-${random_integer.suffix.result}"

  replica {
    region = "us-east-2"
  }

  tags = {
    Name = "Aurora DB Credentials"
  }
}

resource "aws_secretsmanager_secret_version" "db_credentials_version" {
  secret_id     = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = "foo",
    password = "foobarbaz"
  })
}
