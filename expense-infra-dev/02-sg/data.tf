# data "aws_ssm_parameter" "expense_vpc" {
#   name = "/${var.project_name}/${var.environment}/vpc_id"
# }
data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.project_name}/${var.environment}/vpc_id"
}