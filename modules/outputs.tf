output "s3-id" {
  description = "ID of the S3 instance"
  value       = aws_s3_bucket.myBucket.id
}

output "dydb-id" {
  description = "ID of the dynamodb instance"
  value       = aws_dynamodb_table.myDynamo.id
}
