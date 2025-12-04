# main.tf (Append this to the end of your existing file)

# --- API Gateway Resources (The Web Server/Router) ---

# main.tf (Missing Block 1: Data Archive)
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "../lambda_function/lambda_handler.py"
  output_path = "lambda.zip"
}

# main.tf (Missing Block 2: IAM Role)
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
}

# main.tf (Missing Block 3: AWS Lambda Function)
resource "aws_lambda_function" "my_lambda" {
  function_name    = var.function_name
  role             = aws_iam_role.lambda_exec_role.arn
  handler          = var.handler
  runtime          = var.runtime
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  # You might also want to add memory_size and timeout here
}

# 1. API Gateway Resource (The API Host)
resource "aws_apigatewayv2_api" "http_api" {
  name          = "${var.function_name}-api"
  protocol_type = "HTTP"
  # COMMENT: HTTP APIs are faster and cheaper than REST APIs for simple Lambda integration.
}

# 2. Integration (The Connector)
resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id             = aws_apigatewayv2_api.http_api.id
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
  integration_uri    = aws_lambda_function.my_lambda.arn # Links to your existing Lambda ARN
  passthrough_behavior = "WHEN_NO_MATCH"
  # COMMENT: AWS_PROXY integration automatically handles the request/response mapping for Lambda.
}

# 3. Route (The Path Definition)
resource "aws_apigatewayv2_route" "default_route" {
  api_id    = aws_apigatewayv2_api.http_api.id
  # Route ANY HTTP method (GET, POST, PUT, etc.) on ANY path
  route_key = "ANY /{proxy+}" 
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
  # COMMENT: The {proxy+} variable captures everything after the base URL, directing all traffic to Lambda.
}

# 4. Deployment/Stage (Makes the API public)
resource "aws_apigatewayv2_stage" "default_stage" {
  api_id      = aws_apigatewayv2_api.http_api.id
  name        = "$default" # The default deployment stage
  auto_deploy = true
}

# 5. Permission (Security Grant)
resource "aws_lambda_permission" "apigw_lambda_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.my_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
  # COMMENT: This IAM policy explicitly grants API Gateway the right to execute your Lambda function.
}

