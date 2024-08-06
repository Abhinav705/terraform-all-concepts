# Declare the data source
data "aws_availability_zones" "available" {
  state = "available" #since we have mentioned region as us-east-1 on provider.tf it will fetch all the zones
  #from this region
}

data "aws_vpc" "default" {
  default = true #this gives the default vpc id which will be created automatically
} 

data "aws_route_table" "main" { #this sourcing is for fetching the default route table which is created for 
#default vpc
  vpc_id = data.aws_vpc.default.id
  filter {
    name = "association.main"
    values = ["true"]
  }
}