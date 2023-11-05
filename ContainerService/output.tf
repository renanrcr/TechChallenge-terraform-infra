output "task_definition_arn" {
  description = "Task definition ARN Outputs"
  value = "${aws_ecs_task_definition.aws-ecs-task.arn}"
}