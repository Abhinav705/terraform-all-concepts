resource "aws_instance" "expense" {
  for_each = var.instances_info #for looping and creating 3 instances
  ami           = data.aws_ami.ami_info.id
  vpc_security_group_ids = ["sg-0412e220d8d44e326"]
  instance_type =  each.value #condition where if it is db instance then t3.small else t3.micro
  tags = merge( 
    var.common_tags,{
      Name = "${each.key}"
      Module = "${each.key}"
      Environment = var.environment
    }
  ) #merge function here merges the both common_tag values and values specific to the instances
}
