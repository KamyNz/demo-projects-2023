#Variables for networking module
variable "owner" {
  description = "Owner of the app"
  default = "cmartinez"
}

variable "OTU" {
  description = "Organizational Unit"
  default = "aas-demo"
}

variable "cidr_block" {
  default = "10.0.0.0/16"
}

variable "enable_dns_support" {
  default = true
}

variable "enable_dns_hostnames" {
  default = true
}

variable "cidr_block_public" {
  default = "10.0.1.0/24"
}

variable "cidr_block_private" {
  default = "10.0.2.0/24"
}

variable "map_public_ip_on_launch" {
  default = true
}

variable "availability_zone_public" {
  default = "us-east-1a"
}

variable "availability_zone_private" {
  default = "us-east-1b"
}
