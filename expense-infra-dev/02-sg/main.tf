# module "db" {
#   source = "../../terraform-security-group"
#   #it takes the module files from the above mentioned path
#   project_name = var.project_name
#   environment = var.environment
#   sg_description = "Sg for mysql DB instances"
#   vpc_id = data.aws_ssm_parameter.expense_vpc.value
#   #vpc id we are data sourcing from ssm parameter which was created inside parameter.tf file in 01-vpc folder
#   #inside variable "value" we have stored the vpc id so we are data sourcing it
#   common_tags = var.common_tags
#   sg_name = "db"
# }

# module "backend" {
#   source = "../../terraform-security-group"
#   #it takes the module files from the above mentioned path
#   project_name = var.project_name
#   environment = var.environment
#   sg_description = "Sg for backend instances"
#   vpc_id = data.aws_ssm_parameter.expense_vpc.value
#   #vpc id we are data sourcing from ssm parameter which was created inside parameter.tf file in 01-vpc folder
#   #inside variable "value" we have stored the vpc id so we are data sourcing it
#   common_tags = var.common_tags
#   sg_name = "backend"
# }

# module "frontend" {
#   source = "../../terraform-security-group"
#   #it takes the module files from the above mentioned path
#   project_name = var.project_name
#   environment = var.environment
#   sg_description = "Sg for frontend instances"
#   vpc_id = data.aws_ssm_parameter.expense_vpc.value
#   #vpc id we are data sourcing from ssm parameter which was created inside parameter.tf file in 01-vpc folder
#   #inside variable "value" we have stored the vpc id so we are data sourcing it
#   common_tags = var.common_tags
#   sg_name = "frontend"
# }

# module "bastion" { #bastion is jump server.. we use this server to connect to private servers
#   source = "../../terraform-security-group"
#   #it takes the module files from the above mentioned path
#   project_name = var.project_name
#   environment = var.environment
#   sg_description = "Sg for bastion instances"
#   vpc_id = data.aws_ssm_parameter.expense_vpc.value
#   #vpc id we are data sourcing from ssm parameter which was created inside parameter.tf file in 01-vpc folder
#   #inside variable "value" we have stored the vpc id so we are data sourcing it
#   common_tags = var.common_tags
#   sg_name = "bastion"
# }

# # module "ansible" {
# #   source = "../../terraform-security-group"
# #   #it takes the module files from the above mentioned path
# #   project_name = var.project_name
# #   environment = var.environment
# #   sg_description = "Sg for ansible instances"
# #   vpc_id = data.aws_ssm_parameter.expense_vpc.value
# #   #vpc id we are data sourcing from ssm parameter which was created inside parameter.tf file in 01-vpc folder
# #   #inside variable "value" we have stored the vpc id so we are data sourcing it
# #   common_tags = var.common_tags
# #   sg_name = "ansible"
# # }

# module "app_alb" { #app_alb is load balancer server.. we use this for load balancing
#   source = "../../terraform-security-group"
#   #it takes the module files from the above mentioned path
#   project_name = var.project_name
#   environment = var.environment
#   sg_description = "Sg for app ALB instances"
#   vpc_id = data.aws_ssm_parameter.expense_vpc.value
#   #vpc id we are data sourcing from ssm parameter which was created inside parameter.tf file in 01-vpc folder
#   #inside variable "value" we have stored the vpc id so we are data sourcing it
#   common_tags = var.common_tags
#   sg_name = "app_alb"
# }

# module "vpn" { #vpn
#   source = "../../terraform-security-group"
#   #it takes the module files from the above mentioned path
#   project_name = var.project_name
#   environment = var.environment
#   sg_description = "Sg for VPN instances"
#   vpc_id = data.aws_ssm_parameter.expense_vpc.value
#   #vpc id we are data sourcing from ssm parameter which was created inside parameter.tf file in 01-vpc folder
#   #inside variable "value" we have stored the vpc id so we are data sourcing it
#   common_tags = var.common_tags
#   sg_name = "VPN"
#   inbound_rules = var.vpn_sg_rules #we are defining inbound rules for VPN for given ports.. refer variables.tf
# }


# resource "aws_security_group_rule" "db_backend" { #inbound traffic to db from backend
#   type              = "ingress"
#   from_port         = 3306 #mysql port 3306
#   to_port           = 3306
#   protocol          = "tcp"
#   source_security_group_id = module.backend.sg_id # source is where you are getting traffic from
#   security_group_id = module.db.sg_id #db security group id
# }

# resource "aws_security_group_rule" "db_bastion" { #inbound traffic to db from bastion
#   type              = "ingress"
#   from_port         = 3306 #mysql port 3306 (since ssh will not work for DB..since RDS managed by AWS)
#   to_port           = 3306
#   protocol          = "tcp"
#   source_security_group_id = module.bastion.sg_id # source is where you are getting traffic from
#   security_group_id = module.db.sg_id #db security group id
# }

# resource "aws_security_group_rule" "db_vpn" { #inbound traffic to db from bastion
#   type              = "ingress"
#   from_port         = 3306 #mysql port 3306 (since ssh will not work for DB..since RDS managed by AWS)
#   to_port           = 3306
#   protocol          = "tcp"
#   source_security_group_id = module.vpn.sg_id # source is where you are getting traffic from
#   security_group_id = module.db.sg_id #db security group id
# }

# # resource "aws_security_group_rule" "backend_frontend" { #inbound traffic to backend from frontend
# #   type              = "ingress"
# #   from_port         = 8080 #backend port 8080
# #   to_port           = 8080
# #   protocol          = "tcp"
# #   source_security_group_id = module.frontend.sg_id # source is where you are getting traffic from
# #   security_group_id = module.backend.sg_id #backend security group id
# # }

# resource "aws_security_group_rule" "backend_bastion" { #inbound traffic to backend from bastion
#   type              = "ingress"
#   from_port         = 22 #bastion connects through SSH port number 22
#   to_port           = 22
#   protocol          = "tcp"
#   source_security_group_id = module.bastion.sg_id # source is where you are getting traffic from
#   security_group_id = module.backend.sg_id #backend security group id
# }

# resource "aws_security_group_rule" "backend_app_alb" { #inbound traffic to backend from app_alb
#   type              = "ingress"
#   from_port         = 8080 #alb managed by Aws, so no SSH
#   to_port           = 8080
#   protocol          = "tcp"
#   source_security_group_id = module.app_alb.sg_id # source is where you are getting traffic from
#   security_group_id = module.backend.sg_id #backend security group id
# }

# resource "aws_security_group_rule" "backend_vpn_http" { #inbound traffic to backend from vpn http
#   type              = "ingress"
#   from_port         = 80 #http listens on port 80
#   to_port           = 80
#   protocol          = "tcp"
#   source_security_group_id = module.vpn.sg_id # source is where you are getting traffic from
#   security_group_id = module.backend.sg_id #backend security group id
# }

# resource "aws_security_group_rule" "backend_vpn_ssh" { #inbound traffic to backend from vpn thru ssh
#   type              = "ingress"
#   from_port         = 22 
#   to_port           = 22
#   protocol          = "tcp"
#   source_security_group_id = module.vpn.sg_id # source is where you are getting traffic from
#   security_group_id = module.backend.sg_id #backend security group id
# }

# resource "aws_security_group_rule" "app_alb_vpn" { #inbound traffic to app_alb from vpn
#   type              = "ingress"
#   from_port         = 80
#   to_port           = 80
#   protocol          = "tcp"
#   source_security_group_id = module.vpn.sg_id # source is where you are getting traffic from
#   security_group_id = module.app_alb.sg_id #backend security group id
# }


# # resource "aws_security_group_rule" "backend_ansible" { #inbound traffic to backend from ansible
# #   type              = "ingress"
# #   from_port         = 22 #bastion connects through SSH port number 22
# #   to_port           = 22
# #   protocol          = "tcp"
# #   source_security_group_id = module.ansible.sg_id # source is where you are getting traffic from
# #   security_group_id = module.backend.sg_id #backend security group id
# # }

# resource "aws_security_group_rule" "frontend_public" { #inbound traffic to frontend from public
#   type              = "ingress"
#   from_port         = 80 #frontend port 80
#   to_port           = 80
#   protocol          = "tcp"
#   cidr_blocks = ["0.0.0.0/0"] 
#   security_group_id = module.frontend.sg_id #frontend security group id
# }

# resource "aws_security_group_rule" "frontend_bastion" { #inbound traffic to frontend from bastion
#   type              = "ingress"
#   from_port         = 22 #SSH
#   to_port           = 22
#   protocol          = "tcp"
#   source_security_group_id = module.bastion.sg_id
#   security_group_id = module.frontend.sg_id #frontend security group id
# }

# # resource "aws_security_group_rule" "frontend_ansible" { #inbound traffic to frontend from ansible
# #   type              = "ingress"
# #   from_port         = 22 #SSH
# #   to_port           = 22
# #   protocol          = "tcp"
# #   source_security_group_id = module.ansible.sg_id
# #   security_group_id = module.frontend.sg_id #frontend security group id
# # }

# resource "aws_security_group_rule" "bastion_public" { #inbound traffic to bastion from public
#   type              = "ingress"
#   from_port         = 22 #frontend port 80
#   to_port           = 22
#   protocol          = "tcp"
#   cidr_blocks = ["0.0.0.0/0"] 
#   security_group_id = module.bastion.sg_id #bastion security group id
# }

# # resource "aws_security_group_rule" "ansible_public" { #inbound traffic to ansible from public
# #   type              = "ingress"
# #   from_port         = 22 #frontend port 80
# #   to_port           = 22
# #   protocol          = "tcp"
# #   cidr_blocks = ["0.0.0.0/0"] 
# #   security_group_id = module.ansible.sg_id #bastion security group id
# # }

module "db" {
  source = "../../terraform-security-group"
  project_name = var.project_name
  environment = var.environment
  sg_description = "SG for DB MySQL Instances"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = var.common_tags
  sg_name = "db"
}

module "backend" {
  source = "../../terraform-security-group"
  project_name = var.project_name
  environment = var.environment
  sg_description = "SG for Backend Instances"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = var.common_tags
  sg_name = "backend"
}

module "app_alb" {
  source = "../../terraform-security-group"
  project_name = var.project_name
  environment = var.environment
  sg_description = "SG for APP ALB Instances"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = var.common_tags
  sg_name = "app-alb"
}


module "frontend" {
  source = "../../terraform-security-group"
  project_name = var.project_name
  environment = var.environment
  sg_description = "SG for Frontend Instances"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = var.common_tags
  sg_name = "frontend"
}

module "web_alb" {
  source = "../../terraform-security-group"
  project_name = var.project_name
  environment = var.environment
  sg_description = "SG for Web ALB Instances"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = var.common_tags
  sg_name = "web-alb"
}

module "bastion" {
  source = "../../terraform-security-group"
  project_name = var.project_name
  environment = var.environment
  sg_description = "SG for Bastion Instances"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = var.common_tags
  sg_name = "bastion"
}

module "vpn" {
  source = "../../terraform-security-group"
  project_name = var.project_name
  environment = var.environment
  sg_description = "SG for VPN Instances"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = var.common_tags
  sg_name = "vpn"
  ingress_rules = var.vpn_sg_rules
}

# DB is accepting connections from backend
resource "aws_security_group_rule" "db_backend" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.backend.sg_id # source is where you are getting traffic from
  security_group_id = module.db.sg_id
}

resource "aws_security_group_rule" "db_bastion" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id # source is where you are getting traffic from
  security_group_id = module.db.sg_id
}

resource "aws_security_group_rule" "db_vpn" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id # source is where you are getting traffic from
  security_group_id = module.db.sg_id
}

resource "aws_security_group_rule" "backend_app_alb" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.app_alb.sg_id # source is where you are getting traffic from
  security_group_id = module.backend.sg_id
}

resource "aws_security_group_rule" "backend_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id # source is where you are getting traffic from
  security_group_id = module.backend.sg_id
}

resource "aws_security_group_rule" "backend_vpn_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id # source is where you are getting traffic from
  security_group_id = module.backend.sg_id
}

resource "aws_security_group_rule" "backend_vpn_http" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id # source is where you are getting traffic from
  security_group_id = module.backend.sg_id
}

resource "aws_security_group_rule" "app_alb_vpn" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id # source is where you are getting traffic from
  security_group_id = module.app_alb.sg_id
}

resource "aws_security_group_rule" "app_alb_bastion" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id # source is where you are getting traffic from
  security_group_id = module.app_alb.sg_id
}

resource "aws_security_group_rule" "app_alb_frontend" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.frontend.sg_id # source is where you are getting traffic from
  security_group_id = module.app_alb.sg_id
}

resource "aws_security_group_rule" "frontend_web_alb" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.web_alb.sg_id 
  security_group_id = module.frontend.sg_id
}

resource "aws_security_group_rule" "frontend_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id # source is where you are getting traffic from
  security_group_id = module.frontend.sg_id
}

resource "aws_security_group_rule" "frontend_vpn" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id # source is where you are getting traffic from
  security_group_id = module.frontend.sg_id
}

resource "aws_security_group_rule" "web_alb_public" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.web_alb.sg_id
}

resource "aws_security_group_rule" "web_alb_public_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.web_alb.sg_id
}

resource "aws_security_group_rule" "bastion_public" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.bastion.sg_id
}

# #added as part of Jenkins CICD
# resource "aws_security_group_rule" "backend_default_vpc" {
#   type              = "ingress"
#   from_port         = 22
#   to_port           = 22
#   protocol          = "tcp"
#   cidr_blocks = ["172.31.0.0/16"]
#   security_group_id = module.backend.sg_id
# }

# #added as part of Jenkins CICD
# resource "aws_security_group_rule" "frontend_default_vpc" {
#   type              = "ingress"
#   from_port         = 22
#   to_port           = 22
#   protocol          = "tcp"
#   cidr_blocks = ["172.31.0.0/16"]
#   security_group_id = module.frontend.sg_id
# }

# not required, we can connect from VPN
# resource "aws_security_group_rule" "frontend_public" {
#   type              = "ingress"
#   from_port         = 22
#   to_port           = 22
#   protocol          = "tcp"
#   cidr_blocks = ["0.0.0.0/0"]
#   security_group_id = module.frontend.sg_id
# }