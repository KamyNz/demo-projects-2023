variable "host_os" {
  type    = string
  default = "linux_mac"
}

variable "aws_iam_role_name" {
  default = "ec2_role"
}

variable "aws_iam_instance_profile_name" {
  default = "ec2_instance_profile"
}

variable "aws_iam_policy_attachment_name" {
  default = "EC2S3AccessAttachment"
}

variable "aws_iam_policy_attachment_policy_arn" {
  default = "arn:aws:iam::aws:policy/AmazonS3FullAccess" # Change policy as per specific requirements
}

variable "aws_instance_type" {
  default = "t2.micro"
}

variable "aws_instance_key_name" {
  default = "main-tf-cmartinez-keypair"
}

variable "owner" {
  description = "Owner of the app"
}

variable "OTU" {
  description = "Owner of the app"
  default = "aas-demo"
}

