variable "project_name" {
  type = string 
}
variable "environment" {
  type = string 
}
variable "common_tags" {
  type = map 
}
variable "sg_name" {
  type = string 
}
variable "sg_description" {
  type = string 
}
variable "vpc_id" {
  type = string
}
variable "sg_tags" {
  type = map 
  default = {}
}
variable "outbound_rules" {
  type = list #we are creating rules for outbound traffic. 
  default = [
    {
        from_port = 0 #all ports
        to_port = 0
        protocol = "-1" #all protocols
        cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}
variable "inbound_rules" { #user has to give rules for inbound traffic
  type = list 
  default = []
}

