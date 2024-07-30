resource "aws_route53_record" "expense" {
  
  count=length(var.expense_instances)
  zone_id = var.zone_id #zoneid will be taken from aws route53 account
  name    = var.expense_instances[count.index]=="frontend" ? var.domain_name : "${var.expense_instances[count.index]}.${var.domain_name}"
  #if instance is frontend then abhinavk.fun else db/backend.abhinavk.fun
  type    = "A"
  ttl     = 1
  records = var.expense_instances[count.index] == "frontend" ? [aws_instance.expense[count.index].public_ip] : [aws_instance.expense[count.index].private_ip]
  #if the instance is frontend we take public ip else private ip
  #var.expense_instances will give you list of all instances information, so we can take ip addresses from that list of instances
  allow_overwrite = true #it will overwrite the records if they are already created

}