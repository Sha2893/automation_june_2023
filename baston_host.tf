resource "aws_instance" "bastion" {
  ami           = "ami-06b09bfacae1453cb"
  instance_type = "t2.micro"
  key_name      = "Practical"
  subnet_id     = element([for each_subnet in aws_subnet.private_subnet : each_subnet.id], 0)

  tags = {
    Name = local.bastion_host
  }
  vpc_security_group_ids = [aws_security_group.bastion_host.id]

}

