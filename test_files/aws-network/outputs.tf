output "vpc_id" {
  value       = aws_vpc.vpc.id
  description = "VPC ID."
}

output "private_subnets" {
  value       = { for k, v in aws_subnet.private : k => v.id }
  description = "Private Subnet IDs."
}

output "public_subnet_1" {
  value       = var.enable_internet_connectivity ? aws_subnet.public_1[0].id : null
  description = "Public Subnet 1 ID."
}

output "public_subnet_2" {
  value       = var.enable_internet_connectivity ? aws_subnet.public_2[0].id : null
  description = "Public Subnet 2 ID."
}
