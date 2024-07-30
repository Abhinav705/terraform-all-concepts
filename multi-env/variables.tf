variable "instances_info" {
    type = map
    # default ={
    #     db = "t3.small"
    #     backend = "t3.micro"
    #     frontend = "t3.micro"
    #}
}

variable "common_tags" {
    default = {
        Project = "Expense"
        terraform = "true"
    }
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
variable "environment" {
  
}
