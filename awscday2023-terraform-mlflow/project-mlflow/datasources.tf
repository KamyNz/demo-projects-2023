data "aws_ami" "mlflow-server-awscday" {
  most_recent = true
  owners      = ["099720109477"] # Ojo, this must be between ""

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

}
