##1: Create vpc
resource "aws_vpc" "dev-efi-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "dev-efimerio-caoba"
  }
}

##2: Create a public subnet
resource "aws_subnet" "dev-efi-public_subnet" {
  vpc_id                  = aws_vpc.dev-efi-vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name = "dev-efimerio-caoba-public"
  }
}

##3: Create Internet Gateway
resource "aws_internet_gateway" "dev-efi-gw" {
  #referenc vpc created below
  vpc_id = aws_vpc.dev-efi-vpc.id

  tags = {
    Name = "dev-efimerio-caoba-igw"
  }
}

##3: Create custom routble table. This is using a resource route table
resource "aws_route_table" "dev-efi-public_rt" {
  vpc_id = aws_vpc.dev-efi-vpc.id
  tags = {
    Name = "dev-efimerio-caoba-public-rt"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.dev-efi-public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.dev-efi-gw.id
}
##4: Create A Route Table Association. Close the gap between route_table and subnet
###
resource "aws_route_table_association" "dev-efi-public_association" {
  subnet_id      = aws_subnet.dev-efi-public_subnet.id
  route_table_id = aws_route_table.dev-efi-public_rt.id

}

##5: Create a Security Group
resource "aws_security_group" "dev-efi-sg" {
  #name of security group, description of sg
  name        = "dev-efi-sg"
  description = "Security Group for Ephemeral Development Environment"
  vpc_id      = aws_vpc.dev-efi-vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["XXX.XXX.XXX.XXX/32"]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

##6: Using data source to get AMI according to filters -> Done in datasource.tf file
#Go to AWS console, and ge the owner of the following ami_id = ami-0fc5d935ebf8bc3bc
#Owner: 099720109477

##7:Create a keypair, if needed. Take into account: https://youtu.be/iRaai1IBlB0?t=3081
# resource "aws_key_pair" "main-tf-cmartinez-keypair" {
#   key_name = "main-tf-cmartinez-keypair"
#   public_key = file("~/.ssh/xxx")

# }

##8:Create an ami according to datasources.tf and keypair
resource "aws_instance" "mlflow-demo-tf" {
  instance_type          = "t2.micro"
  ami                    = data.aws_ami.mlflow-demo-tf.id
  key_name               = "main-tf-cmartinez-keypair"
  vpc_security_group_ids = [aws_security_group.dev-efi-sg.id]
  subnet_id              = aws_subnet.dev-efi-public_subnet.id
  user_data              = file("userdata.tpl")


  root_block_device {
    volume_size = 10
  }

  tags = {
    Name = "dev-efimerio-caoba-instance"
  }

  #Adding provisioner, check: https://developer.hashicorp.com/terraform/language/resources/provisioners/syntax
  provisioner "local-exec" {
    command = templatefile("${var.host_os}-ssh-config.tpl", {
      hostname     = self.public_ip,
      user         = "ubuntu",
      identityfile = "/Users/camilamv/Documents/Learning/04-CommunityEvents/demo-terraform-2023/awscday2023-terraform-mlflow/project/main-tf-cmartinez-keypair.pem"

    })
    #interpreter = [ "", ""] #No need in mac, it will default in OS.
    interpreter = var.host_os == "windows" ? ["Powershell", "-Command"] : ["bash", "-c"]

  }
}

