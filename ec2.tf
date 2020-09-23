data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
    owners = ["099720109477"]
}


resource "aws_instance" "myec2-instance" {
  ami           = "ami-0e82959d4ed12de3f"
  instance_type = "t2.micro"
  key_name               = "HHA"
  vpc_security_group_ids = [aws_security_group.terraform_sg.id]

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get -y install apache2",
      "sudo systemctl start apache2"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("./HHA.pem")
      host        = self.public_ip
    }
  }
}
