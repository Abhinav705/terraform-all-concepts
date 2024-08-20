resource "aws_lb" "web_alb" {
  name               = "${var.project_name}-${var.environment}-web-alb"
  internal           = false #web-alb is in facing is public , so internal is false
  load_balancer_type = "application"
  security_groups    = [data.aws_ssm_parameter.web_alb_sg_id.value]
  subnets            = split(",", data.aws_ssm_parameter.public_subnet_ids.value) #we need to give min 2 subnet id's
  #so we are passing both the private sunet id's and it splits based on "," using plit function

  enable_deletion_protection = false

  tags = merge(
    var.common_tags,
    {
        Name = "${var.project_name}-${var.environment}-web-alb"
    }
  )
}

resource "aws_lb_listener" "http" { #adding listener
  load_balancer_arn = aws_lb.web_alb.arn #taking load balancer details arn=amazon resource name
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response" #fixed response

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>This is fixed response from WEB ALB</h1>"
      status_code  = "200"
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = "443"

  protocol          = "HTTPS"
  certificate_arn   = data.aws_ssm_parameter.acm_certificate_arn.value
  ssl_policy        = "ELBSecurityPolicy-2016-08"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>This is fixed response from Web ALB HTTPS</h1>"
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
      name    = "web-${var.environment}" #sending all the traffic which are coming as web-dev.abhinavk.fun
      #to the load balancer
      type    = "A"
      allow_overwrite = true
      alias   = {
        name    = aws_lb.web_alb.dns_name #dns_name and zoneid are outputs from records module
        zone_id = aws_lb.web_alb.zone_id
      }
    }
  ]
}