######################################
#Outputs to get key information
######################################
output "aws_vpc" {
  value = aws_vpc.dev-efi-vpc.id
}

output "aws_subnet_public" {
  value = aws_subnet.public_subnet.id
}

output "aws_subnet_private" {
  value = aws_subnet.private_subnet.id
}

output "aws_s3_bucket" {
  value = aws_s3_bucket.mlflow_bucket_awscday.id
}

output "aws_iam_role_id" {
  value = aws_iam_role.ec2_role_awscday.id
}

output "aws_iam_role_name" {
  value = aws_iam_role.ec2_role_awscday.name
}

output "aws_iam_instance_profile_name" {
  value = aws_iam_instance_profile.ec2_instance_profile_awscday.name
}

output "aws_iam_instance_profile_uniqueidc" {
  value = aws_iam_instance_profile.ec2_instance_profile_awscday.unique_id
}

output "aws_iam_policy_attachment" {
  value = aws_iam_policy_attachment.s3_access_attachment_awscday.id
}

output "aws_security_group" {
  value = aws_security_group.instance_sg.id
}

output "aws_instance_id" {
  value = aws_instance.mlflow-server-awscday.id
}

output "aws_instance_keyname" {
  value = aws_instance.mlflow-server-awscday.key_name
}

output "aws_instance_public_ip" {
  value = aws_instance.mlflow-server-awscday.public_ip
}

output "aws_lb" {
  value = aws_lb.alb-mlflow-awscday.id
}
