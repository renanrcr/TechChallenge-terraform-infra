resource "aws_security_group" "http" {
	name = "alb_security_group_http"
	description = "Terraform load balancer security group HTTP"
	vpc_id = "${var.vpc}"

	ingress {
		cidr_blocks = ["0.0.0.0/0"]
		from_port = 80
		protocol = "TCP"
		to_port = 80
	}
}
resource "aws_security_group" "https" {
	name = "alb_security_group_https"
	description = "Terraform load balancer security group HTTPS"
	vpc_id = "${var.vpc}"

	ingress {
		cidr_blocks = ["0.0.0.0/0"]
		from_port = 443
		protocol = "TCP"
		to_port = 443
	}
}
resource "aws_security_group" "egress_all" {
	name = "alb_security_group_egress"
	description = "Terraform load balancer security group EGRESS"
	vpc_id = "${var.vpc}"

	egress {
		cidr_blocks = ["0.0.0.0/0"]
		from_port = 0
		protocol = "-1"
		to_port = 0
	}
}

resource "aws_security_group" "ingress_api" {
	name = "alb_security_group_ingress"
	description = "Terraform load balancer security group INGRESS"
	vpc_id = "${var.vpc}"

	ingress {
		cidr_blocks = ["0.0.0.0/0"]
		from_port = 80
		protocol = "TCP"
		to_port = 80
	}
}

resource "aws_lb" "this" {
	load_balancer_type = "application"

	security_groups = [
		aws_security_group.egress_all.id,
		aws_security_group.http.id,
		aws_security_group.https.id,
	]

	subnets = "${var.public_subnets_id}"
}
resource "aws_lb_target_group" "this" {
	port = 80
	protocol = "HTTP"
	target_type = "ip"
 	vpc_id = "${var.vpc}"

	depends_on = [aws_lb.this]
}
resource "aws_lb_listener" "this" {
	load_balancer_arn = aws_lb.this.arn
	port = 80
	protocol = "HTTP"

	default_action {
		target_group_arn = aws_lb_target_group.this.arn
		type = "forward"
	}
}