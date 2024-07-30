# locals {
#     instance_type = var.expense_instances[count.index]=="db"?"t3.small":"t3.micro"
#     record_name = var.expense_instances[count.index]=="frontend" ? var.domain_name : "${var.expense_instances[count.index]}.${var.domain_name}"
#     records = var.expense_instances[count.index] == "frontend" ? [aws_instance.expense[count.index].public_ip] : [aws_instance.expense[count.index].private_ip]
# }

#we can't use expressions inside locals when we are using count or count.index
#this count.index will not be accessible inside the locals block of code. 