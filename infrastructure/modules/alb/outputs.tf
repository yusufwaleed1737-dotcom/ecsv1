output "alb_tg_arn" {
    value = aws_lb_target_group.alb_tg.arn
}

output "alb_arn" {
    value = aws_lb.alb.arn
}

output "alb_dns_name" {
    value = aws_lb.alb.dns_name
}

output "alb_dns_zone_id" {
    value = aws_lb.alb.zone_id
}

output "https_listener_arn" {
    value = aws_lb_listener.https_listener.arn
}