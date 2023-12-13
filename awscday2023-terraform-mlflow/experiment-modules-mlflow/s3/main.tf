# S3 Bucket Creation
resource "aws_s3_bucket" "mlflow_bucket_awscday" {
  bucket = var.aws_s3_bucket_name
  acl    = var.aws_s3_bucket_acl

  tags = {
    Name = "dev-efimerio-caoba",
    TerminationProtection = "false",
    Owner = var.owner,
    OTU = var.OTU
  }
}
