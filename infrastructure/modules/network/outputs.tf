output "vpc_id" {
    value = aws_vpc.main.id
}

output "privatesubnet_ids" {
    value = [aws_subnet.private1.id, aws_subnet.private2.id]
}

output "publicsubnet_ids" {
    value = [aws_subnet.public1.id, aws_subnet.public2.id]
}

