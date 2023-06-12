resource "aws_vpc" "main" {
  cidr_block       = "192.168.0.0/24"
  instance_tenancy = "default"

  tags = {
    Name = "MYVPC2"
  }
}

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


