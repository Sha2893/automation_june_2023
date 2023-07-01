resource "aws_instance" "web" {
  ami           = "ami-06b09bfacae1453cb"
  instance_type = "t2.micro"
  key_name      = "Practical"
  subnet_id     = element([for each_subnet in aws_subnet.private_subnet : each_subnet.id], 0)

  tags = {
    Name = local.web_server
  }
  vpc_security_group_ids = [aws_security_group.main.id]
}

resource "aws_security_group" "main" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]

  }

  dynamic "ingress" {
    for_each = var.inbound_rules_web
    
    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.protocol
      cidr_blocks = [aws_vpc.main.cidr_block]
    }

  }


  /* ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]

  }
*/

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Allow_web_server"
  }
}