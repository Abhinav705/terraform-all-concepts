#Project-related
variable "project_name" {
    type = string
}
variable "Environment" {
    default = "dev"
}
variable "common_tags" {
    type = map
}

#VPC-related
variable "vpc_cidr_block" {
    type = string
    default = "10.0.0.0/16"
}
variable "dns_support" {
    type = bool
    default = true
}

variable "vpc_tags" {
    type = map 
    default = {}
}
#igw tag
variable "igw_tags" {
  type = map 
  default = {}
}
#public subnet tags
variable "public_subnet_cidr_tags" {
  type = map 
  default = {}
}

variable "public_subnet_cidrs" {
    type = list 
    validation {
      condition = length(var.public_subnet_cidrs) == 2
      error_message = "Please Enter two public subnet CIDR"
    }
  
}