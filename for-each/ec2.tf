resource "aws_instance" "expense" {
  for_each = var.instances_info #for looping and creating 3 instances
  ami           = data.aws_ami.ami_info.id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  instance_type =  each.value#condition where if it is db instance then t3.small else t3.micro
  tags = merge( 
    var.common_tags,{
      Name = each.key
      Module = each.key
    }
  ) #merge function here merges the both common_tag values and values specific to the instances
}



resource "aws_security_group" "allow_ssh" {
  name        = var.sg_name
  description = var.sg_description
  
  ingress {
    from_port        = var.ssh_port
    to_port          = var.ssh_port
    protocol         = var.protocol
    cidr_blocks      = var.sg_cidr
  }
  egress {
    from_port        = 0  #from 0 to 0 means opening all protocols
    to_port          = 0
    protocol         = "-1" #all protocols
    cidr_blocks      = var.sg_cidr
  }

  tags = {
    Name = "allow_ssh"
    createdBy = "Abhinav"
  }
}