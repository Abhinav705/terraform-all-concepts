#Project-related
variable "project_name" {
    type = string
}
variable "environment" {
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

variable "private_subnet_cidr_tags" {
    type = map 
    default = {}
}

variable "database_subnet_cidr_tags" {
  type = map 
  default = {}
}

variable "eip_tags" {
  type = map 
  default = {}
}

variable "nat_gateway_tags" {
  type = map 
  default = {}
}

variable "public_route_table_tags" {
  type = map 
  default = {}
}

variable "private_route_table_tags" {
  type = map 
  default = {}
}

variable "database_route_table_tags" {
  type = map 
  default = {}
}

#public subnet cidrs
variable "public_subnet_cidrs" {
    type = list 
    validation {
      condition = length(var.public_subnet_cidrs) == 2 # we are asking user to send 2 public subnet cidrs
      error_message = "Please Enter two public subnet CIDR"
    }
}
#private subnet cidrs
variable "private_subnet_cidrs" {
    type = list 
    validation {
      condition = length(var.private_subnet_cidrs) == 2 # we are asking user to send 2 private subnet cidrs
      error_message = "Please Enter two private subnet CIDR"
    }
}
#database subnet cidrs
variable "database_subnet_cidrs" {
    type = list 
    validation {
      condition = length(var.database_subnet_cidrs) == 2 # we are asking user to send 2 database subnet cidrs
      error_message = "Please Enter two database subnet CIDR"
    }
}


variable "database_subnet_group_tags" {
   type = map 
   default = {}
}
#peering variables
variable "is_peering_required" {
    type = bool 
    default = false
}

variable "acceptor_vpc_id" {
    type = string
    default = ""
}

variable "vpc_peering_tags" {
    type = map 
    default = {}
}