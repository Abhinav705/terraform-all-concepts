#Priority of variable declaration
#1. Command line
#2. tf vars
#3. Environment variables
#4. var default value
variable "image_id" {
    type = string
    default = "ami-041e2ea9402c46c32"
    description = "RHEL-9 AMI Image"
}
variable "instance_type" {
    type = string
    default = "t3.micro"
}
variable "tags" {
    default = {
        Project = "Expense"
        Environment = "DB"
        Module = "DB"
        Name = "DB"
    }
}
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