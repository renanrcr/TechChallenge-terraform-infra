resource "aws_vpc" "main" {
 cidr_block = "${var.cidr_block}"
 enable_dns_hostnames = true
 enable_dns_support = true
 tags = {
  Name = "${var.environment}-vpc"
 }
}

resource "aws_subnet" "public_subnets" {
 count = "${length(var.public_subnet_cidrs)}"
 vpc_id = aws_vpc.main.id
 cidr_block = "${element(var.public_subnet_cidrs, count.index)}"
 availability_zone = element(var.azs, count.index)
 tags = {
  Name = "${var.environment}-public-subnet-${count.index + 1}"
 }
}

resource "aws_subnet" "private_subnet" {
 count = "${length(var.private_subnet_cidrs)}"  
 vpc_id = aws_vpc.main.id
 cidr_block = "${element(var.private_subnet_cidrs, count.index)}"
 availability_zone = element(var.azs, count.index)
 tags = {
  Name = "${var.environment}-private-subnet-${count.index + 1}"
 }
}

resource "aws_internet_gateway" "gw" {
 vpc_id = aws_vpc.main.id
 tags = {
  Name = "${var.environment}-gw"
 }
}

resource "aws_route_table" "second_rt" {
 vpc_id = aws_vpc.main.id
 route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.gw.id
 }
 tags = {
  Name = "${var.environment}-second-route-table"
 }
}

resource "aws_route_table_association" "public_subnet_asso" {
 count = length(var.public_subnet_cidrs)
 subnet_id = element(aws_subnet.public_subnets[*].id, count.index)
 route_table_id = aws_route_table.second_rt.id
}