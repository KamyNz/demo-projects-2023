variable "owner" {
  description = "Owner of the app"
}

variable "OTU" {
  description = "Owner of the app"
  default = "aas-demo"
}

variable "aws_lb_name" {
  default = "alb-mlflow-awscday"
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

variable "aws_lb_target_group_target_type" {
  default = "instance"
}

variable "aws_lb_listener_port" {
  default = 80
}
variable "aws_lb_listener_protocol" {
  default = "HTTP"
}

