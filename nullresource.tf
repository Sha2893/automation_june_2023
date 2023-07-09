resource "null_resource" "provisioner" {
  triggers = {
    always_run = timestamp()
  }
  depends_on = [aws_instance.bastion]

  connection {
    host        = aws_instance.bastion.public_ip
    type        = "ssh"
    user        = "ec2-user"
    private_key = var.mykey
  }

  # provisioner "local-exec" {
  #   command = "scp -o StrictHostKeyChecking=no -i var.mykey var ec2-user@${aws_instance.bastion.public_ip}:~"
  # }

  provisioner "file" {
    # source      = "~/keypair"
    content     = var.mykey
    destination = "/home/ec2-user/mykey"
    on_failure  = continue
  }


  provisioner "remote-exec" {
    inline = [
      "chmod 400 mykey"
    ]
  }

}