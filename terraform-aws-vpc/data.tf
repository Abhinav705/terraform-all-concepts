# Declare the data source
data "aws_availability_zones" "available" {
  state = "available" #since we have mentioned region as us-east-1 on provider.tf it will fetch all the zones
  #from this region
}