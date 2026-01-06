output "name_cloudwatch_group" {
    value = aws_cloudwatch_log_group.ecs_logs.name
}

output "ecs_iam_role_arn" {
    value = aws_iam_role.ecs_task_execution_role.arn
}