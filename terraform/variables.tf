# variables.tf

variable "aws_region" {
  description = "The AWS region where resources will be created."
  type        = string
  default     = "us-east-1" 
  # COMMENT: Define a default region. Change this based on your preference.
}

variable "function_name" {
  description = "Name for the AWS Lambda function."
  type        = string
  default     = "MyJenkinsCICDLambda" 
  # COMMENT: A unique name for the Lambda resource.
}

variable "runtime" {
  description = "The runtime environment for the Lambda function."
  type        = string
  default     = "python3.11"
  # COMMENT: Should match the version of Python (or Node/Java/etc.) used in the handler file.
}

variable "handler" {
  description = "The entry point (file.function) for the Lambda function."
  type        = string
  default     = "lambda_handler.lambda_handler" 
  # COMMENT: Assumes your file is 'lambda_handler.py' and the function is 'lambda_handler'.
}
