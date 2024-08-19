resource "aws_key_pair" "vpn" {
  key_name   = "vpn"
  #public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQz1x2cEikKDEY0aIj41qgxMCP/iteneqXSIFZBp5vizPvaoIR3Um9xK7PGoW8giupGn+EPuxIA4cDM4vzOqOkiMPhz5XK0whEjkVzTo4+S0puvDZuwIsdiW9mxhJc7tgBNL0cYlWSYVkz4G/fslNfRPW5mYAM49f4fhtxPb5ok4Q2Lg9dPKVHO/Bgeu5woMc7RY0p1ej6D4CKFE6lymSDJpW0YHX/wqE9+cfEauh7xZcG0q9t2ta6F6fmX0agvpFyZo8aFbXeUBr7osSCJNgvavWbM/06niWrOvYX2xwWdhXmXSrbX8ZbabVohBK41 email@example.com"
  #you can paste the key directly
  #public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK+KhHkaF3GSyVwfh1EWTB/SwrxRpdpWeWFCAwxpsUy3 HP@DESKTOP-3N33ERG"
  public_key = file("~/.ssh/openvpn.pub")

}

module "vpn" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "${var.project_name}-${var.environment}-vpn"

  instance_type          = "t3.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.vpn_sg_id.value]
  # convert StringList to list and get first element
  subnet_id              = local.public_subnet_id #vpn creates in public subnet
  ami = data.aws_ami.ami_info.id
  tags = merge(
    var.common_tags,{
        Name = "${var.project_name}-${var.environment}-vpn"
    }
  )
}