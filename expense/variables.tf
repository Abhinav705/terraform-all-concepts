#ec2 instance variables
variable "image_id" {
    type = string
    default = "ami-041e2ea9402c46c32"
    description = "RHEL-9 AMI Image"
}
variable "instance_type" {
    type = string
    default = "t3.micro"
}
variable "common_tags" {
    default = {
        Project = "Expense"
        Environment = "dev"
        terraform = "true"
    }
}
variable "expense_instances" {
  type = list(string)
  default = [ "db","backend","frontend" ]
}
#security group variables
variable "sg_name" {
    default = "allow_ssh"
}
variable "sg_description" {
  default = "Allowing SSH Access"
}
variable "ssh_port" {
  type = number
  default = 22
}
variable "protocol" {
    type = string
    default = "tcp"
}
variable "sg_cidr" {
  type = list(string)
  default = [ "0.0.0.0/0" ]
}
#r53 variables
variable "zone_id" {
    default = "Z01026453KA3987W3MALR"
} 
variable "domain_name" {
  default = "abhinavk.fun"
}
