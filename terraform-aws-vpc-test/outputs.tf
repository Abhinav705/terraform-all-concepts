
# output "azs_info" {
#     value = module.aws_vpc.azs # module.<module-name>.<output>
# }

output "vpc_id" {
  value = module.aws_vpc.vpc_id
}

output "public_subnet_list" {
  value = module.aws_vpc.public_subnet_ids
}

output "igw_id" {
  value = module.aws_vpc.igw_id
}
