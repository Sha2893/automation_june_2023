resource "aws_vpc" "main" {
  cidr_block           = var.cidr_for_vpc
  instance_tenancy     = var.tenancy
  enable_dns_hostnames = var.dns_hostname_enabled
  enable_dns_support   = var.dns_supported_enabled
  tags = {
    Name = local.vpc_name_label

  }
}
resource "aws_subnet" "private_subnet" {
  for_each          = { for index, az_name in slice(data.aws_availability_zones.main.names, 0, 2) : index => az_name }
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.cidr_for_vpc, length(data.aws_availability_zones.main.names) > 3 ? 4 : 3, each.key)
  availability_zone = each.value
  tags = {
    name = "private-subnet-${each.key}"
  }
}

resource "aws_subnet" "public_subnet" {
  for_each          = { for index, az_name in slice(data.aws_availability_zones.main.names, 0, 2) : index => az_name }
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.cidr_for_vpc, length(data.aws_availability_zones.main.names) > 3 ? 4 : 3, each.key + length(data.aws_availability_zones.main.names))
  availability_zone = each.value
  tags = {
    name = "public-subnet-${each.key}"
  }

}

resource "aws_default_route_table" "main" {
  default_route_table_id = aws_vpc.main.default_route_table_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }



  tags = {
    Name = "private_RT_${var.vpc_name}"
  }
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "public_rt_${var.vpc_name}"
  }
}


resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "igw-${var.vpc_name}"
  }
}
# route table association for private subnets 
resource "aws_route_table_association" "private_subnet_association" {
  for_each       = { for index, each_subnet in aws_subnet.private_subnet : index => each_subnet.id }
  subnet_id      = each.value
  route_table_id = aws_default_route_table.main.id
}

resource "aws_route_table_association" "public_subnet_association" {
  for_each       = { for index, each_subnet in aws_subnet.public_subnet : index => each_subnet.id }
  subnet_id      = each.value
  route_table_id = aws_route_table.main.id
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.main.id
  subnet_id     = element([for each_subnet in aws_subnet.public_subnet : each_subnet.id], 0)

  tags = {
    Name = "nat_gw_${var.vpc_name}"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.main]
}

resource "aws_eip" "main" {
  domain = "vpc"
}























/*
resource "aws_subnet" "subnet_az1" {
  vpc_id   = aws_vpc.main.id
  for_each = { "PublicSubnet1" : "192.168.0.0/27", "praivatesubnet1" : "192.168.0.32/27", "PrivateSubnet2" : "192.168.0.64/27" }

  cidr_block        = each.value
  availability_zone = "us-east-1a"

  tags = {
    Name = "${each.key}"
  }
}
resource "aws_subnet" "subnet_az2" {
  vpc_id   = aws_vpc.main.id
  for_each = { "PublicSubnet2" : "192.168.0.96/27", "PrivateSubnet3" : "192.168.0.128/27", "PrivateSubnet4" : "192.168.0.160/27" }

  cidr_block        = each.value
  availability_zone = "us-east-1b"

  tags = {
    Name = "${each.key}"
  }
}
/*resource "aws_subnet" "main" {
  
  count      = length(var.cidr_subnet)
  vpc_id     = aws_vpc.main.id
    cidr_block = element(var.cidr_subnet, count.index)
    tags = {
      name = "subnet-${count.index}"
    }
  }

  variable "no_of_subnets" {

    type = number
    description = "no of subnets to be created"
    default = 6
  }
   
 

variable "cidr_subnet" {
  type = list(string)
  description = "list of cidr subnets"
  default = ["192.168.0.0/27", "192.168.0.32/27", "192.168.0.64/27", "192.168.0.96/27", "192.168.0.128/27","192.168.0.160/27"]

}







/*resource "aws_subnet" "main2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "192.168.0.32/27"

  tags = {
    Name = "Public_Subnet2"
  }
}

resource "aws_subnet" "main3" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "192.168.0.64/27"

  tags = {
    Name = "PrivateSubnet1"
  }
}

resource "aws_subnet" "main4" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "192.168.0.96/27"

  tags = {
    Name = "PrivateSubnet2"
  }
}

resource "aws_subnet" "main5" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "192.168.0.128/27"

  tags = {
    Name = "PrivateSubnet3"
  }
}
resource "aws_subnet" "main6" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "192.168.0.160/27"

  tags = {
    Name = "PrivateSubnet4"
  }
}

*/


