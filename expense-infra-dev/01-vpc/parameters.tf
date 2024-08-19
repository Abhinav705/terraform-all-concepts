resource "aws_ssm_parameter" "vpc" {
  name  = "/${var.project_name}/${var.environment}/vpc_id" #ssm param name
  type  = "String"
  value = module.aws_vpc.vpc_id #we are passing the vpc id to ssm parameter store which is created from module
}


resource "aws_ssm_parameter" "public_subnet_ids" {
  name  = "/${var.project_name}/${var.environment}/public_subnet_ids"
  type  = "StringList" #ips are stored as list..so we are converting them into string list
  value = join("," ,module.aws_vpc.public_subnet_ids) # converting list to string list
}

#["id1","id2"] terraform format
# id1, id2 -> AWS SSM format
resource "aws_ssm_parameter" "private_subnet_ids" {
  name  = "/${var.project_name}/${var.environment}/private_subnet_ids"
  type  = "StringList"
  value = join(",",module.aws_vpc.private_subnet_ids) # converting list to string list
}

resource "aws_ssm_parameter" "db_subnet_group_name" {
  name  = "/${var.project_name}/${var.environment}/db_subnet_group_name"
  type  = "String"
  value = module.aws_vpc.database_subnet_group_name
}