data "aws_ssm_parameter" "bastion_sg_id" {
  name = "/${var.project_name}/${var.environment}/bastion_sg_id"
}

data "aws_ssm_parameter" "app_alb_sg_id" {
  name = "/${var.project_name}/${var.environment}/app_alb_sg_id"
}

data "aws_ssm_parameter" "vpn_sg_id" {
  name = "/${var.project_name}/${var.environment}/vpn_sg_id"
}

data "aws_ssm_parameter" "public_subnet_ids" {
  name = "/${var.project_name}/${var.environment}/public_subnet_ids"
}

data "aws_ami" "ami_info" {
  most_recent      = true
  owners           = ["973714476881"]  #we are quering and filtering and fetching AMI ID 

  filter {
    name   = "name"
    values = ["RHEL-9-DevOps-Practice"] #filtering name
  }

  filter {
    name   = "root-device-type" #filtering root-device-type
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type" #filtering virtualization-type
    values = ["hvm"]
  }
}

data "aws_vpc" "default"{  #quering all the default vpc details
    default = true
}