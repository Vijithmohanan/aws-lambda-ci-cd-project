# main.tf (A highly simplified version)

# Data source to package the function code into a zip
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "../lambda_function/lambda_handler.py" # Relative path to your Python file
  output_path = "lambda.zip"
  # COMMENT: This packages the source code into the deployment format AWS needs.
}

# IAM Role for the Lambda function (The permissions it needs)
resource "aws_iam_role" "lambda_exec_role" {
  name = "${var.function_name}-exec-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
  # COMMENT: The Assume Role Policy grants permission for the AWS Lambda service to assume this role.
}

# Lambda function resource
resource "aws_lambda_function" "my_lambda" {
  function_name    = var.function_name
  role             = aws_iam_role.lambda_exec_role.arn
  handler          = "lambda_handler.lambda_handler" # File.function_name
  runtime          = var.runtime
  filename         = data.archive_file.lambda_zip.output_path # Use the packaged zip file
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  # COMMENT: The handler is the function to execute (lambda_handler.py -> lambda_handler function).
}
