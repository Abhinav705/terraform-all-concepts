variable "project_name" {
  default = "expense"
}

variable "environment" {
  default = "dev"
}

variable "common_tags" {
  default = {
    Project = "expense"
    Environment = "dev"
    Terraform = "true"
  }
}

variable "zone_name" {
  default = "abhinavk.fun"
}

variable "zone_id" {
  default = "Z01026453KA3987W3MALR"
}