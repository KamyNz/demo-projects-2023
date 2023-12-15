variable "owner" {
  description = "Owner of the app"
}

variable "OTU" {
  description = "Owner of the app"
  default     = "aas-demo"
}

variable "aws_s3_bucket_name" {
  default = "mlflow-artifact-store-efimero"
}

variable "aws_s3_bucket_acl" {
  default = "private"
}
