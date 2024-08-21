resource "aws_lb" "app_alb" {
  name               = "${var.project_name}-${var.environment}-app-alb"
  internal           = true #app-alb is in private subnet, so internal is true
  load_balancer_type = "application"
  security_groups    = [data.aws_ssm_parameter.app_alb_sg_id.value]
  subnets            = split(",", data.aws_ssm_parameter.private_subnet_ids.value) #we need to give min 2 subnet id's
  #so we are passing both the private sunet id's and it splits based on "," using plit function

  enable_deletion_protection = false

  tags = merge(
    var.common_tags,
    {
        Name = "${var.project_name}-${var.environment}-app-alb"
    }
  )
}

resource "aws_lb_listener" "http" { #adding listener
  load_balancer_arn = aws_lb.app_alb.arn #taking load balancer details
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response" #fixed response

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>This is fixed response from APP ALB</h1>"
      status_code  = "200"
    }
  }
}

module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"

  zone_name = var.zone_name
  
  records = [
    {
      name    = "*.app-${var.environment}" #sending all the traffic which are coming as *-dev.abhinavk.fun
      #to the load balancer
      type    = "A"
      allow_overwrite = true
      alias   = { #route traffic to the load balancer
        name    = aws_lb.app_alb.dns_name #dns_name and zoneid are outputs from records module
        zone_id = aws_lb.app_alb.zone_id
      }
    }
  ]
}