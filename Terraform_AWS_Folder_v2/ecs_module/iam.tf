
# iam_role.tf

resource "aws_iam_role" "foo" {
  name = "foo-ecs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Principal = {
          Service = "ecs.amazonaws.com"
        }
        Effect    = "Allow"
        Sid       = ""
      },
    ]
  })
}

resource "aws_iam_role_policy" "foo" {
  name = "foo-ecs-policy"
  role = aws_iam_role.foo.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action   = "ecs:DescribeTasks"
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}
