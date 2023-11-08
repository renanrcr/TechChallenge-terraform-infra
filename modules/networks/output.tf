output "vpc_id" {
  description = "VPC Outputs"
  value = "${aws_vpc.vpc.id}"
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet[*].id
  description = "The ID of the subnet Outputs"
}

output "private_subnet_id" {
  value = aws_subnet.private_subnet[*].id
  description = "The ID of the private subnet Outputs"
}