terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "eu-west-1"
}

resource "aws_s3_bucket" "myBucket" {
  bucket = "bucket-vsugana"
  force_destroy = true
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
    Name        = "dynamodb-table"
  }
}