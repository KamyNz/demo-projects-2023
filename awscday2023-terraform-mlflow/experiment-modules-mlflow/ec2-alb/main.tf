# IAM Role Configuration for EC2 Instance
resource "aws_iam_role" "ec2_role_awscday" {
  name = var.aws_iam_role_name

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
    Name                  = "dev-efimerio-caoba-public",
    TerminationProtection = "false",
    Owner                 = var.owner,
    OTU                   = var.OTU
  }
}

resource "aws_iam_instance_profile" "ec2_instance_profile_awscday" {
  name = var.aws_iam_instance_profile_name
  role = aws_iam_role.ec2_role_awscday.id

  tags = {
    TerminationProtection = "false",
    Owner                 = var.owner,
    OTU                   = var.OTU
  }
}

resource "aws_iam_policy_attachment" "s3_access_attachment_awscday" {
  name       = var.aws_iam_policy_attachment_name
  roles      = [aws_iam_role.ec2_role_awscday.name]
  policy_arn = var.aws_iam_policy_attachment_policy_arn
}

# Security Group for EC2 Instance
resource "aws_security_group" "instance_sg" {
  name        = "instance_security_group"
  description = "Security group for EC2 instance"

  #TODO: Change here for module
  vpc_id = var.vpc_id

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
    Name                  = "dev-efimerio-caoba",
    TerminationProtection = "false",
    Owner                 = var.owner,
    OTU                   = var.OTU
  }
}

# EC2 Instance Configuration
resource "aws_instance" "mlflow-server-awscday" {
  instance_type = var.aws_instance_type
  ami           = data.aws_ami.mlflow-server-awscday.id
  key_name      = var.aws_instance_key_name

  #role profile
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile_awscday.name


  #networking
  security_groups = [aws_security_group.instance_sg.id] #there is vpc_security_groups and instance_security_groups
  subnet_id       = var.aws_subnet_public_id
  #TODO: This works without using module. Preguntarle al profe
  #user_data       = file("./userdata.tpl")

  #TODO: This works with using module. Preguntarle al profe
  user_data = file("${path.module}/userdata.tpl")

  #storage
  root_block_device {
    volume_size = 10
  }

  #Adding provisioner, check: https://developer.hashicorp.com/terraform/language/resources/provisioners/syntax
  provisioner "local-exec" {
    command = templatefile("${path.module}/${var.host_os}-ssh-config.tpl", {
      hostname     = self.public_ip,
      user         = "ubuntu",
      identityfile = "/Users/camilamv/Documents/Learning/04-CommunityEvents/demo-terraform-2023/awscday2023-terraform-mlflow/project-mlflow/main-tf-cmartinez-keypair.pem"

    })
    interpreter = var.host_os == "windows" ? ["Powershell", "-Command"] : ["bash", "-c"]

  }

  tags = {
    Name                  = "dev-efimerio-caoba-instance",
    TerminationProtection = "false",
    Owner                 = var.owner,
    OTU                   = var.OTU
  }


}

######################################
#RESOURCES FOR ALB
######################################

# Application Load Balancer Configuration
resource "aws_lb" "alb-mlflow-awscday" {
  name               = var.aws_lb_name
  internal           = var.internal
  load_balancer_type = var.load_balancer_type
  #TODO: FALTA
  subnets = [var.aws_subnet_public_id, var.aws_subnet_private_id]

  tags = {
    Name                  = "dev-efimerio-caoba",
    TerminationProtection = "false",
    Owner                 = var.owner,
    OTU                   = var.OTU
  }
}

# Target Group Configuration for ALB
resource "aws_lb_target_group" "tg-awscday" {
  name     = var.aws_lb_target_group_name
  port     = var.aws_lb_target_group_port
  protocol = var.aws_lb_target_group_protocol
  #TODO: FALTA
  vpc_id      = var.vpc_id
  target_type = var.aws_lb_target_group_target_type

  tags = {
    Name                  = "dev-efimerio-caoba",
    TerminationProtection = "false",
    Owner                 = var.owner,
    OTU                   = var.OTU
  }
}

# ALB Listener for HTTP and HTTPS
resource "aws_lb_listener" "http_listener_awscday" {
  load_balancer_arn = aws_lb.alb-mlflow-awscday.arn
  port              = var.aws_lb_listener_port
  protocol          = var.aws_lb_listener_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg-awscday.arn
  }

  tags = {
    Name                  = "dev-efimerio-caoba",
    TerminationProtection = "false",
    Owner                 = var.owner,
    OTU                   = var.OTU
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
