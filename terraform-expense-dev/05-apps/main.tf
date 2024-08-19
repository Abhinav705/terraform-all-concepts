module "backend" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "${var.project_name}-${var.environment}-backend"

  instance_type          = "t3.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.backend_sg_id.value]
  # convert StringList to list and get first element
  subnet_id              = local.private_subnet_id #backend creates in private subnet
  ami = data.aws_ami.ami_info.id

  tags = merge(
    var.common_tags,{
        Name = "${var.project_name}-${var.environment}-backend"
    }
  )
}

module "frontend" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "${var.project_name}-${var.environment}-frontend"

  instance_type          = "t3.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.frontend_sg_id.value]
  # convert StringList to list and get first element
  subnet_id              = local.public_subnet_id #backend creates in public subnet
  ami = data.aws_ami.ami_info.id

  tags = merge(
    var.common_tags,{
        Name = "${var.project_name}-${var.environment}-frontend"
    }
  )
}

module "ansible" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "${var.project_name}-${var.environment}-ansible"

  instance_type          = "t3.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.ansible_sg_id.value]
  # convert StringList to list and get first element
  subnet_id              = local.public_subnet_id #backend creates in public subnet
  ami = data.aws_ami.ami_info.id
  user_data = file("expense.sh") #we pass the shell script as user_data
  #in that file we will mention the comands to execute in the server.

  tags = merge(
    var.common_tags,{
        Name = "${var.project_name}-${var.environment}-ansible"
    }
  )
  depends_on = [ module.backend, module.frontend ] # ansible needs to create after creation of backend, frontend
  #hence we are telling it to first execute frontend, backend and then come to ansible
}


module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"

  zone_name = var.zone_name #zone_name =abhinavk.fun

  records = [
    {
      name    = "backend"#it will append name+zone_name = backend.abhinavk.fun
      type    = "A" #A is used to map the another ip 
      ttl = 1
      records = [
        module.backend.private_ip #updating the domain with private ip of backend server
      ]
    },
    {
        name="frontend" #frontend.abhinavk.fun
        type = "A"
        ttl=1
        records=[module.frontend.private_ip] #mapping private ip to frontend server. we are not mapping
        #public ip to frontend due to security reasons.
    },
    {
        name=""#abhinavk.fun
        type="A"
        ttl=1 
        records=[module.frontend.public_ip]
    }
  ]
  
}


