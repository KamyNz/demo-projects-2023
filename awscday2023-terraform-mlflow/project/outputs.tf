######################################
#Outputs to get key information
######################################
output "aws_vpc" {
  value = aws_vpc.dev-efi-vpc.id
}

output "aws_subnet" {
  value = aws_subnet.dev-efi-public_subnet.id
}

output "aws_internet_gateway" {
  value = aws_internet_gateway.dev-efi-gw.id
}

output "aws_route_table" {
  value = aws_route_table.dev-efi-public_rt.id
}

output "aws_route_table_association" {
  value = aws_route_table_association.dev-efi-public_association.id
}

output "aws_security_group" {
  value = aws_security_group.dev-efi-sg.id
}

output "aws_instance_id" {
  value = aws_instance.mlflow-demo-tf.id
}

output "aws_instance_keyname" {
  value = aws_instance.mlflow-demo-tf.key_name
}

output "aws_instance_public_ip" {
  value = aws_instance.mlflow-demo-tf.public_ip
}
