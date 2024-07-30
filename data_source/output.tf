output "ami_info" {
  value = data.aws_ami.ami_id.id  #printing the ami info which is gathered from data sourcing
}

output "vpc_info" {
    value = data.aws_vpc.default #printing the vpc info which is gathered from data sourcing
}