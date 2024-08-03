resource "aws_instance" "db" {
  ami           = var.ami_id
  vpc_security_group_ids = var.vpc_id
  instance_type = var.instance_type
  tags = var.tags
}



