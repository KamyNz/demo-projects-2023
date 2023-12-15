######################################
#Variables for networking module
######################################
#Variables for networking module
variable "owner" {
  description = "Owner of the app"
  #default     = "cmartinez" #When using for all modules, it should written
}

variable "OTU" {
  description = "Organizational Unit"
  default     = "aas-demo"
}

variable "cidr_block" {
  default = "10.0.0.0/16"
}

variable "enable_dns_support" {
  default = true
}

variable "enable_dns_hostnames" {
  default = true
}

variable "cidr_block_public" {
  default = "10.0.1.0/24"
}

variable "cidr_block_private" {
  default = "10.0.2.0/24"
}

variable "map_public_ip_on_launch" {
  default = true
}

variable "availability_zone_public" {
  default = "us-east-1a"
}

variable "availability_zone_private" {
  default = "us-east-1b"
}

######################################
##Variables for EC2
######################################
variable "host_os" {
  type    = string
  default = "linux_mac"
}

variable "aws_iam_role_name" {
  default = "ec2_role_demo"
}

variable "aws_iam_instance_profile_name" {
  default = "ec2_instance_profile_demo"
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

#Variables for ALB
variable "aws_lb_name" {
  default = "alb-mlflow-awscday-demo"
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

variable "aws_lb_target_group_type" {
  default = "instance"
}

variable "aws_lb_listener_port" {
  default = 80
}
variable "aws_lb_listener_protocol" {
  default = "HTTP"
}

######################################
##Variables for S3 Module
######################################

variable "aws_s3_bucket_name" {
  default = "mlflow-artifact-store-demoF"
}

variable "aws_s3_bucket_acl" {
  default = "private"
}
