resource "aws_ecs_cluster" "this" {
 name = "${var.environment}-cluster"
 tags = {
  Name = "${var.environment}-ecs"
 }
}

resource "aws_cloudwatch_log_group" "this" {
  name = "/aws/ecs/${aws_ecs_cluster.this.name}"
  retention_in_days = 30
}

resource "aws_ecs_cluster_capacity_providers" "this" {
  capacity_providers = ["FARGATE"]
  cluster_name = aws_ecs_cluster.this.name
}

resource "aws_iam_role_policy_attachment" "default" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role = aws_iam_role.task_exec.name
}

data "aws_iam_policy_document" "task_exec_assume" {
  statement {
    sid = "ECSTaskExecutionAssumeRole"
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "task_exec" {
  name = "taskRole"
  assume_role_policy = data.aws_iam_policy_document.task_exec_assume.json
}

data "aws_iam_policy_document" "task_exec" {
  statement {
    sid = "Logs"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = ["*"]
  }

  statement {
    sid = "GetSecrets"
    actions = ["secretsmanager:GetSecretValue"]
    resources = [var.arns]
  }
}

resource "aws_iam_policy" "policy" {
  name = "getSecretELog"
  policy = data.aws_iam_policy_document.task_exec.json
}

resource "aws_iam_role_policy_attachment" "task_exec_additional" {
  role = aws_iam_role.task_exec.name
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_ecs_task_definition" "this" {
  container_definitions = jsonencode([{
    essential = true,
    image = "${var.image}",
    name = "${var.service_name_alb}",
    portMappings = [
      {
        containerPort = 80
        hostPort = 80
        appProtocol = "http"
        protocol = "tcp"
    }],
  }])
  cpu = 256
  execution_role_arn = aws_iam_role.task_exec.arn
  task_role_arn = aws_iam_role.task_exec.arn
  family = "${var.service_name_alb}"
  memory = 512
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
}

resource "aws_ecs_service" "this" {
  cluster = aws_ecs_cluster.this.id
  desired_count = 1
  launch_type = "FARGATE"
  name = "${var.service_name}"
  task_definition = aws_ecs_task_definition.this.arn

  lifecycle {
    ignore_changes = [desired_count, task_definition]
  }

  load_balancer {
    container_name = "${var.service_name_alb}"
    container_port = 80
    target_group_arn = var.arns
  }

  network_configuration {
    security_groups = [
      "${var.lb_engress_id}",
      "${var.lb_ingress_id}"
    ]
    subnets = var.public_subnets_id
    assign_public_ip = true
  }
}