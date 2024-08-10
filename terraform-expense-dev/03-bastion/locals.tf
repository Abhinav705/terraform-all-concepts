locals {
  public_subnet_id = element(split(",", data.aws_ssm_parameter.public_subnet_ids.value), 0)
  #taking stringlist of public ip and splitting them into two seperate ones based on comma and taking 
  #the first element of the list using element function
}