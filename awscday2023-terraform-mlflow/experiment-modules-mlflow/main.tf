#Using module NETWORKING
module "networking" {
  source                    = "./networking"
  owner                     = var.owner
  OTU                       = var.OTU
  cidr_block                = var.cidr_block
  enable_dns_support        = var.enable_dns_support
  enable_dns_hostnames      = var.enable_dns_hostnames
  cidr_block_public         = var.cidr_block_public
  map_public_ip_on_launch   = var.map_public_ip_on_launch
  availability_zone_public  = var.availability_zone_public
  cidr_block_private        = var.cidr_block_private
  availability_zone_private = var.availability_zone_private
}

#Using module EC2
module "ec2-alb" {
  source                               = "./ec2-alb"
  vpc_id                               = module.networking.vpc_id
  aws_subnet_public_id                 = module.networking.aws_subnet_public_id
  aws_subnet_private_id                = module.networking.aws_subnet_private_id
  owner                                = var.owner
  OTU                                  = var.OTU
  aws_iam_role_name                    = var.aws_iam_role_name
  aws_iam_instance_profile_name        = var.aws_iam_instance_profile_name
  aws_iam_policy_attachment_name       = var.aws_iam_policy_attachment_name
  aws_iam_policy_attachment_policy_arn = var.aws_iam_policy_attachment_policy_arn
  aws_instance_type                    = var.aws_instance_type
  aws_instance_key_name                = var.aws_instance_key_name
}

module "s3" {
  source             = "./s3"
  owner              = var.owner
  OTU                = var.OTU
  aws_s3_bucket_name = var.aws_s3_bucket_name
  aws_s3_bucket_acl  = var.aws_s3_bucket_acl

}
