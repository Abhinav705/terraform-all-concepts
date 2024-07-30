resource "aws_route53_record" "expense" {
  
  for_each = aws_instance.expense #taking output from instances which are created and fetching the key and value pairs
  zone_id = var.zone_id #zoneid will be taken from aws route53 account
  name    = each.key =="frontend" ? var.domain_name : "${each.key}.${var.domain_name}"
  #if instance is frontend then abhinavk.fun else db/backend.abhinavk.fun
  type    = "A"
  ttl     = 1
  records = each.key == "frontend" ? [each.value.public_ip] : [each.value.private_ip]
  #if the instance is frontend we take public ip else private ip
  #var.expense_instances will give you list of all instances information, so we can take ip addresses from that list of instances
  allow_overwrite = true #it will overwrite the records if they are already created

}