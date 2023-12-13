##1: Create vpc
resource "aws_vpc" "dev-efi-vpc" {
  cidr_block           = var.cidr_block
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = {
    Name                  = "dev-efimerio-caoba",
    TerminationProtection = "false",
    Owner = var.owner,
    OTU = var.OTU
  }
}

#VPC asignas el rango mayor
#Subnets se les asigna el rango menor
#Calculos de subnetting.

##2: Create public_subnet and private_subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.dev-efi-vpc.id
  cidr_block              = var.cidr_block_public
  map_public_ip_on_launch = var.map_public_ip_on_launch
  availability_zone       = var.availability_zone_public

  tags = {
    Name                  = "dev-efimerio-caoba-public",
    TerminationProtection = "false",
    Owner = var.owner,
    OTU = var.OTU
  }
}

# 2 Escenarios:
# Escenario 1: userdata.tpl -> usarlo en la primera vez para adecuacion de ambiente
# Escenario 2: userdata.tpl -> usarlo cuando instancia se ejecute con las mismas sentencia
# cada vez que se reinicie

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.dev-efi-vpc.id
  cidr_block        = var.cidr_block_private
  availability_zone = var.availability_zone_private

  tags = {
    Name                  = "dev-efimerio-caoba-private",
    TerminationProtection = "false",
    Owner = var.owner,
    OTU = var.OTU
  }
}

##3: Create Internet Gateway
resource "aws_internet_gateway" "gw" {
  #referenc vpc created below
  vpc_id = aws_vpc.dev-efi-vpc.id

  tags = {
    Name                  = "dev-efimerio-caoba-igw",
    TerminationProtection = "false",
    Owner = var.owner,
    OTU = var.OTU
  }
}

##4: Create custom routble table. This is using a resource route table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.dev-efi-vpc.id
  tags = {
    Name                  = "dev-efimerio-caoba-public-rt",
    TerminationProtection = "false",
    Owner = var.owner,
    OTU = var.OTU
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
