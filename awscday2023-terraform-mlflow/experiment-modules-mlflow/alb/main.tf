# Application Load Balancer Configuration
resource "aws_lb" "alb-mlflow-awscday" {
  name               = var.aws_lb_name
  internal           = var.internal
  load_balancer_type = var.load_balancer_type
  #TODO: FALTA
  subnets = [module.networking.aws_subnet_public_id, module.networking.aws_subnet_private_id]

  tags = {
    Name                  = "dev-efimerio-caoba",
    TerminationProtection = "false",
    Owner = var.owner,
    OTU = var.OTU
  }
}

# Target Group Configuration for ALB
resource "aws_lb_target_group" "tg-awscday" {
  name     = var.aws_lb_target_group_name
  port     = var.aws_lb_target_group_port
  protocol = var.aws_lb_target_group_protocol
  #TODO: FALTA
  vpc_id      = module.networking.vpc_id
  target_type = var.aws_lb_target_group_target_type

  tags = {
    Name                  = "dev-efimerio-caoba",
    TerminationProtection = "false",
    Owner = var.owner,
    OTU = var.OTU
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
    Owner = var.owner,
    OTU = var.OTU
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
