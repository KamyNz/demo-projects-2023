######################################
#Outputs to get key information
######################################
output "vpc_id" {
  value = aws_vpc.dev-efi-vpc.id
}

output "aws_subnet_public_id" {
  value = aws_subnet.public_subnet.id
}

output "aws_subnet_private_id" {
  value = aws_subnet.private_subnet.id
}

output "owner" {
  value = var.owner
}
output "OTU" {
  value = var.OTU
}
