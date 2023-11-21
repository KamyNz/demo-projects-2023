##1: Create vpc
resource "aws_vpc" "dev-efi-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "dev-efimerio-caoba"
  }
}

#VPC asignas el rango mayor
#Subnets se les asigna el rango menor
#Calculos de subnetting.

##2: Create public_subnet and private_subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.dev-efi-vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name = "dev-efimerio-caoba-public"
  }
}

# 2 Escenarios:
# Escenario 1: userdata.tpl -> usarlo en la primera vez para adecuacion de ambiente
# Escenario 2: userdata.tpl -> usarlo cuando instancia se ejecute con las mismas sentencia
# cada vez que se reinicie

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.dev-efi-vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "dev-efimerio-caoba-private"
  }
}

##3: Create Internet Gateway
resource "aws_internet_gateway" "gw" {
  #referenc vpc created below
  vpc_id = aws_vpc.dev-efi-vpc.id

  tags = {
    Name = "dev-efimerio-caoba-igw"
  }
}

##4: Create custom routble table. This is using a resource route table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.dev-efi-vpc.id
  tags = {
    Name = "dev-efimerio-caoba-public-rt"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

##5: Create A Route Table Association. Close the gap between route_table and subnet
###
resource "aws_route_table_association" "dev-efi-public_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id

}

# S3 Bucket Creation
resource "aws_s3_bucket" "mlflow_bucket_awscday" {
  bucket = "mlflow-artifact-store-demo-final"
  acl    = "private"

  tags = {
    Name = "dev-efimerio-caoba"
  }
}

# IAM Role Configuration for EC2 Instance
resource "aws_iam_role" "ec2_role_awscday" {
  name = "ec2_role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "IamPassRole",
        "Effect" : "Allow",
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "dev-efimerio-caoba-public"
  }
}

resource "aws_iam_instance_profile" "ec2_instance_profile_awscday" {
  name = "ec2_instance_profile"
  role = aws_iam_role.ec2_role_awscday.id
}

resource "aws_iam_policy_attachment" "s3_access_attachment_awscday" {
  name       = "EC2S3AccessAttachment"
  roles      = [aws_iam_role.ec2_role_awscday.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess" # Change policy as per specific requirements
}

# Security Group for EC2 Instance
resource "aws_security_group" "instance_sg" {
  name        = "instance_security_group"
  description = "Security group for EC2 instance"

  vpc_id = aws_vpc.dev-efi-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "dev-efimerio-caoba"
  }
}

# EC2 Instance Configuration
resource "aws_instance" "mlflow-server-awscday" {
  instance_type = "t2.micro"
  ami           = data.aws_ami.mlflow-server-awscday.id
  key_name      = "main-tf-cmartinez-keypair"

  #role profile
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile_awscday.name


  #networking
  security_groups = [aws_security_group.instance_sg.id] #there is vpc_security_groups and instance_security_groups
  subnet_id       = aws_subnet.public_subnet.id
  user_data       = file("userdata.tpl")

  #storage
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
      identityfile = "/Users/camilamv/Documents/Learning/04-CommunityEvents/demo-terraform-2023/awscday2023-terraform-mlflow/project-mlflow/main-tf-cmartinez-keypair.pem"

    })
    interpreter = var.host_os == "windows" ? ["Powershell", "-Command"] : ["bash", "-c"]

  }


}

# Application Load Balancer Configuration
resource "aws_lb" "alb-mlflow-awscday" {
  name               = "alb-mlflow-awscday"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.public_subnet.id, aws_subnet.private_subnet.id]

  tags = {
    Name = "dev-efimerio-caoba"
  }
}

# Target Group Configuration for ALB
resource "aws_lb_target_group" "tg-awscday" {
  name        = "tg-awscday"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.dev-efi-vpc.id
  target_type = "instance"

  tags = {
    Name = "dev-efimerio-caoba"
  }
}

# ALB Listener for HTTP and HTTPS
resource "aws_lb_listener" "http_listener_awscday" {
  load_balancer_arn = aws_lb.alb-mlflow-awscday.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg-awscday.arn
  }

  tags = {
    Name = "dev-efimerio-caoba"
  }
}

# resource "aws_lb_listener" "https_listener_awscday" {
#   load_balancer_arn = aws_lb.alb-mlflow-awscday.arn
#   port              = 443
#   protocol          = "HTTPS"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.tg-awscday.arn
#   }
#   tags = {
#     Name = "dev-efimerio-caoba"
#   }
# }
