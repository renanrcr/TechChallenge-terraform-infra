output "lb_target_group_arn" {
  description = "The ID of the security group Outputs"
  value = aws_lb_target_group.alb.arn
}