variable "instance_type" {
    default = {
        dev = "t3.micro"
        prod = "t3.small" #key name and workspace name should be the same
    }
  
}