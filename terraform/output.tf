# output.tf

output "lambda_function_arn" {
  description = "The Amazon Resource Name (ARN) of the deployed Lambda function."
  value       = aws_lambda_function.my_lambda.arn
  # COMMENT: The ARN is a unique identifier used to reference the Lambda in AWS CLI or other services.
}

output "lambda_function_name" {
  description = "The name of the Lambda function."
  value       = aws_lambda_function.my_lambda.function_name
  # COMMENT: Confirms the name that was actually deployed.
}

output "iam_role_name" {
  description = "The name of the IAM execution role created for the Lambda."
  value       = aws_iam_role.lambda_exec_role.name
  # COMMENT: Useful for checking permissions or logs in the AWS Console.
}
