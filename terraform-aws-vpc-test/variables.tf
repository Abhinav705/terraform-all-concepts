variable "project_name" {
  default = "Expense"
}
variable "common_tags" {
    default = {
        Project = "Expense"
        Environment = "dev"
        Terraform = true
    }
}

variable "public_subnet_cidrs" {
  type = list 
  default = ["10.0.1.0/24","10.0.2.0/24"]
}