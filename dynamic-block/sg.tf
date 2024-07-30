resource "aws_security_group" "allow_ssh" {
  name        = "security group"
  description = "allow port 22,80,8080,3306"
  
  dynamic ingress {  #mention dynamic keyword at the block entrance
    for_each = var.allowed_ports  #taking the list of ports from variable allowed ports
    content{ #mention content keyword where the code you need to repeat
        from_port        = ingress.value["port"]  #blockname.value["<key-name>"]
        to_port          = ingress.value["port"]
        protocol         = ingress.value["protocol"]
        cidr_blocks      = ingress.value["allowed_cidr"]
    }
  }
  egress {
    from_port        = 0  #from 0 to 0 means opening all protocols
    to_port          = 0
    protocol         = "-1" #all protocols
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
    createdBy = "Abhinav"
  }
}