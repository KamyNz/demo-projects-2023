variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "aws_subnet_public_id" {
  description = "The ID of the public subnet"
  type        = string
}

variable "aws_subnet_private_id" {
  description = "The ID of the private subnet"
  type        = string
}

variable "owner" {
  description = "Owner of the app"
}

variable "OTU" {
  description = "Owner of the app"
  default     = "aas-demo"
}

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

variable "aws_lb_name" {
  default = "alb-mlflow-awscday"
}

variable "internal" {
  default = false
}

variable "load_balancer_type" {
  default = "application"
}

variable "aws_lb_target_group_name" {
  default = "tg-awscday"
}

variable "aws_lb_target_group_port" {
  default = 80
}

variable "aws_lb_target_group_protocol" {
  default = "HTTP"
}

variable "aws_lb_target_group_target_type" {
  default = "instance"
}

variable "aws_lb_listener_port" {
  default = 80
}
variable "aws_lb_listener_protocol" {
  default = "HTTP"
}


