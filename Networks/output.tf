output "vpc_id" {
  description = "VPC Outputs"
  value = "${aws_vpc.main.id}"
}

output "public_subnet_id" {
  value = aws_subnet.public_subnets[*].id
  description = "The ID of the subnet Outputs"
}

output "private_subnet_id" {
  value = aws_subnet.private_subnets[*].id
  description = "The ID of the private subnet Outputs"
}

output "security_group_id" {
  description = "The ID of the security group Outputs"
  value = aws_security_group.tech_challenge_sg.id
}