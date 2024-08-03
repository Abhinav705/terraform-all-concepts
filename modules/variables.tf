variable "ami_id" {
  type = string
  default = "ami-041e2ea9402c46c32"
}
variable "vpc_id" {
    type = list(string)
    default = [ "sg-0ee8e61412c16f407" ]
}
variable "instance_type" {
    type = string
    default = "t3.micro"
}
variable "tags" {
    type = map
    default = {
        Name = "db"
        terraform = "true"
    }
}