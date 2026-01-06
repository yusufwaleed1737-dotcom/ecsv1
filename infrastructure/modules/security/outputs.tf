output "alb_security_group_id" {
    value = aws_security_group.alb.id
}

output "tasks_security_group_id" {
    value = aws_security_group.tasks.id
}