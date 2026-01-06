output "aws_certificate_arn" {
    value = aws_acm_certificate_validation.acm_validation.certificate_arn
}

output "route_53_zone_id" {
    value = data.aws_route53_zone.route53_zone.zone_id
}

