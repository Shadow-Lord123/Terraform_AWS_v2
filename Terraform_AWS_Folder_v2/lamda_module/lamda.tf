
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/hello.py" 
  output_path = "${path.module}/lambda_function_payload.zip"
}

resource "aws_lambda_function" "test_lambda" {
  filename         = "${path.module}/lambda_function_payload.zip"
  function_name    = "terraform_lambda_function"
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = "hello.lambda_handler" 
  source_code_hash = data.archive_file.lambda.output_base64sha256
  runtime          = "python3.9"  

  environment {
    variables = {
      foo = "bar"
    }
  }
}
