resource "aws_security_group" "alb" {
 name = "techchalleng_terraform_alb_security_group"
 description = "Terraform load balancer security group"
 vpc_id = "${var.vpc}"

 ingress {
  cidr_blocks = ["0.0.0.0/0"]
  from_port = 80
  protocol = "TCP"
  to_port = 80
 }

 ingress {
  cidr_blocks = ["0.0.0.0/0"]
  from_port = 443
  protocol = "TCP"
  to_port = 443
 }

 egress {
  cidr_blocks = ["0.0.0.0/0"]
  from_port = 0
  protocol = "-1"
  to_port = 0
 }

 tags = {
   Name = "${var.environment}-techchallenge-alb-security_group"
  }
}

resource "aws_lb" "alb" {
 load_balancer_type = "application"
 security_groups = [
  aws_security_group.alb.id
 ]
 subnets = "${var.public_subnets_id}"
}

resource "aws_lb_target_group" "alb" {
 port = 80
 protocol = "HTTP"
 target_type = "ip"
 vpc_id = "${var.vpc}"
 depends_on = [aws_lb.alb]
}

resource "aws_lb_listener" "alb" {
 load_balancer_arn = aws_lb.alb.arn
 port = 80
 protocol = "HTTP"
 default_action {
  target_group_arn = aws_lb_target_group.alb.arn
  type = "forward"
 }
}