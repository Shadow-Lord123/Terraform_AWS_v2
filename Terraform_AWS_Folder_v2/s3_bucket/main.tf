resource "aws_s3_bucket" "example" {
  bucket = "kritagya-terraform-bucket"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}