resource "aws_route53_record" "expense" {
  
  for_each = aws_instance.expense #taking output from instances which are created and fetching the key and value pairs
  zone_id = var.zone_id #zoneid will be taken from aws route53 account
  name    = each.key =="frontend-prod" ? var.domain_name : "${each.key}.${var.domain_name}"
  #if instance is frontend-prod then abhinavk.fun else [frontend-dev/db-dev/backend-dev].abhinavk.fun or [db-prod/backend-prod].abhinavk.fun
  type    = "A"
  ttl     = 1
  records = startswith(each.key, "frontend") ? [each.value.public_ip] : [each.value.private_ip]
  #if the instance name starts with frontend then we take public ip else private ip
  #var.expense_instances will give you list of all instances information, so we can take ip addresses from that list of instances
  allow_overwrite = true #it will overwrite the records if they are already created

}