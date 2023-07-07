terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  backend "http" {}

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "eu-west-1"
}
resource "aws_iam_role" "iam-Role" {
  name               = "iam-Role"
  assume_role_policy = file("${path.module}/../ressources/aws_iam_role.json")
}

resource "aws_iam_policy" "policy" {
  name   = "iam-Policy"
  policy = file("${path.module}/../ressources/aws_iam_policy.json")
}

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  role       = aws_iam_role.iam-Role.name
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_s3_bucket" "myBucket" {
  bucket        = "bucket-vsugana"
  force_destroy = true
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.myBucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.myLambdaFunction.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_bucket]
}

resource "aws_dynamodb_table" "myDynamo" {
  name           = "dynamo-vsugana"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "id"
  range_key      = "FileName"

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "FileName"
    type = "S"
  }

  tags = {
    Name = "dynamodb-table"
  }
}

data "archive_file" "zip_the_python_code" {
  type        = "zip"
  source_dir  = "${path.module}/../ressources/python/"
  output_path = "${path.module}/../ressources/lambda_function.zip"
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.myLambdaFunction.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.myBucket.arn
}

resource "aws_lambda_function" "myLambdaFunction" {
  filename      = "${path.module}/../ressources/lambda_function.zip"
  function_name = "myLambdaFunction"
  role          = aws_iam_role.iam-Role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
  depends_on    = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
}




