resource "aws_vpc" "vpc" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "vpc"
  }
}

resource "aws_internet_gateway" "ig" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags = {
    Name = "aws_internet_gateway"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id = "${aws_vpc.vpc.id}"
  count = "${length(var.public_subnet_cidrs)}"
  cidr_block = "${element(var.public_subnet_cidrs, count.index)}"
  availability_zone = "${element(var.availability_zones, count.index)}"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-${element(var.availability_zones, count.index)}"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id = "${aws_vpc.vpc.id}"
  count = "${length(var.private_subnet_cidrs)}"
  cidr_block = "${element(var.private_subnet_cidrs, count.index)}"
  availability_zone = "${element(var.availability_zones, count.index)}"
  map_public_ip_on_launch = false
  tags = {
    Name = "private-subnet-${element(var.availability_zones, count.index)}"
  }
}

resource "aws_db_subnet_group" "db_subnet" {
  name = "aws_db_subnet_group"
  subnet_ids = aws_subnet.public_subnet[*].id
  tags = {
    Name = "aws_db_subnet_group"
  }
}

resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags = {
    Name = "private-route-table"
  }
}
/* Routing table for public subnet */
resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags = {
    Name = "public-route-table"
  }
}
resource "aws_route" "public_internet_gateway" {
  route_table_id = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.ig.id}"
}

resource "aws_route_table_association" "public" {
  count = "${length(var.public_subnet_cidrs)}"
  subnet_id = "${element(aws_subnet.public_subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}
resource "aws_route_table_association" "private" {
  count = "${length(var.private_subnet_cidrs)}"
  subnet_id = "${element(aws_subnet.private_subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.private.id}"
}

resource "aws_security_group" "tech_challenge_security_group" {
  name = "techchallenge-security-group"
  description = "Security Group"
  vpc_id = "${aws_vpc.vpc.id}"
  depends_on = [aws_vpc.vpc]

  ingress {
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    self = true
  }
  
  egress {
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    self = "true"
  }

  tags = {
    Environment = "tech_challenge_security_group"
  }
}