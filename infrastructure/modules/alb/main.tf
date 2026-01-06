# #Accepts 443 and 80 traffic
# resource "aws_lb" "alb" {
#     name = "ECS-App-ALB"
#     internal = false
#     load_balancer_type = "application"
#     security_groups = var.alb_security_group_id
#     # subnets = [module.network.public1.id, module.network.public2.id]
#     subnets = var.publicsubnet_ids

#     enable_deletion_protection = false

#     access_logs {
#         bucket = var.logs_bucket_name
#         enabled = true
#         prefix = "alb-logs"
#     }
# }


# # Target Group for ALB to route traffic to ECS tasks
# ## Target group forwards traffic to ECS tasks on port 80
# resource "aws_lb_target_group" "alb_tg" {
#     name = "ECS-App-TG"
#     port = 80
#     protocol = "HTTP"
#     vpc_id = var.vpc_id
#     target_type = "ip"

#      health_check {
#         path = "/health.json"
#         interval = 30
#         timeout = 5
#         healthy_threshold = 3
#         unhealthy_threshold = 3
#         matcher = "200"
#      }
# }


# # Redirects HTTP to HTTPS 
# resource "aws_lb_listener" "http_listener" {
#     load_balancer_arn = aws_lb.alb.arn
#     port = 80
#     protocol = "HTTP"

#     default_action {
#         type = "redirect"
#         redirect {
#             port = "443"
#             protocol = "HTTPS"
#             status_code = "HTTP_301"
#         }
#     }
# }


# # Traffic decrypted here using ACM certificate and forwarded to target group
# resource "aws_lb_listener" "https_listener" {
#     load_balancer_arn = aws_lb.alb.arn
#     port = 443
#     protocol = "HTTPS"
#     certificate_arn = var.aws_certificate_arn
#     ssl_policy = "ELBSecurityPolicy-TLS13-1-2-2021-06"

#     default_action {
#         type = "forward"
#         target_group_arn = aws_lb_target_group.alb_tg.arn
#         }
#     }

    
# resource "aws_route53_record" "a_record" {
#     # zone_id = data.aws_route53_zone.route53_zone.zone_id
#     zone_id = var.route_53_zone_id
#     name = var.app_domain
#     type = "A"
#     depends_on = [aws_lb.alb]

#     alias {
#         name = aws_lb.alb.dns_name
#         zone_id = aws_lb.alb.zone_id
#         evaluate_target_health = true
#     }
# }   


# Accepts 443 and 80 traffic
resource "aws_lb" "alb" {
    name = var.deployment_id != "" ? "ECS-App-ALB-${var.deployment_id}" : "ECS-App-ALB"
    internal = false
    load_balancer_type = "application"
    security_groups = var.alb_security_group_id
    subnets = var.publicsubnet_ids

    enable_deletion_protection = false

    access_logs {
        bucket = var.logs_bucket_name
        enabled = true
        prefix = "alb-logs"
    }
}

# Target Group for ALB to route traffic to ECS tasks
resource "aws_lb_target_group" "alb_tg" {
    name = var.deployment_id != "" ? "ECS-App-TG-${var.deployment_id}" : "ECS-App-TG"
    port = 80
    protocol = "HTTP"
    vpc_id = var.vpc_id
    target_type = "ip"

    health_check {
        path = "/health.json"
        interval = 30
        timeout = 5
        healthy_threshold = 3
        unhealthy_threshold = 3
        matcher = "200"
    }
}

# Redirects HTTP to HTTPS 
resource "aws_lb_listener" "http_listener" {
    load_balancer_arn = aws_lb.alb.arn
    port = 80
    protocol = "HTTP"

    default_action {
        type = "redirect"
        redirect {
            port = "443"
            protocol = "HTTPS"
            status_code = "HTTP_301"
        }
    }
}

# Traffic decrypted here using ACM certificate and forwarded to target group
resource "aws_lb_listener" "https_listener" {
    load_balancer_arn = aws_lb.alb.arn
    port = 443
    protocol = "HTTPS"
    certificate_arn = var.aws_certificate_arn
    ssl_policy = "ELBSecurityPolicy-TLS13-1-2-2021-06"

    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.alb_tg.arn
    }
}

resource "aws_route53_record" "a_record" {
    zone_id = var.route_53_zone_id
    name = var.app_domain
    type = "A"
    depends_on = [aws_lb.alb]

    alias {
        name = aws_lb.alb.dns_name
        zone_id = aws_lb.alb.zone_id
        evaluate_target_health = true
    }
}