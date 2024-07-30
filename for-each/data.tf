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