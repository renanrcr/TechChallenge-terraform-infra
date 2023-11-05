resource "aws_ecs_cluster" "aws_ecs_cluster" {
 name = "${var.environment}-cluster"
 tags = {
  Name = "${var.environment}-ecs"
 }
}

resource "aws_cloudwatch_log_group" "log-group" {
 name = "${var.environment}-logs"
 tags = {
  Name = "${var.environment}-logs"
 }
}

resource "aws_ecs_cluster_capacity_providers" "capacity_providers" {
 cluster_name = aws_ecs_cluster.aws_ecs_cluster.name
 capacity_providers = ["FARGATE"]
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_default" {
 policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
 role = aws_iam_role.ecsTaskExecutionRole.name
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    sid     = "ECSTaskExecutionAssumeRole"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "taskRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

data "aws_iam_policy_document" "ecsTaskExecutionRole" {
  statement {
    sid = "Logs"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = ["*"]
  }
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "policy" {
  name   = "getSecretELog"
  policy = data.aws_iam_policy_document.ecsTaskExecutionRole.json
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
  role = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_ecs_task_definition" "aws-ecs-task" {
  container_definitions = jsonencode([{
    essential = true,
    image     = "${var.image}",
    name      = "${var.image_name}",
    portMappings = [
      {
        containerPort = 80
        hostPort = 80
        appProtocol = "http"
        protocol = "tcp"
    }],
  }])
  execution_role_arn = aws_iam_role.ecsTaskExecutionRole.arn
  task_role_arn = aws_iam_role.ecsTaskExecutionRole.arn
  family = "${var.image_name}"
  cpu = 256
  memory = 512
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
}

resource "aws_ecs_service" "aws-ecs-service" {
  cluster = aws_ecs_cluster.aws_ecs_cluster.id
  desired_count = 1
  launch_type = "FARGATE"
  scheduling_strategy = "REPLICA"
  name = "${var.service_name}"
  task_definition = aws_ecs_task_definition.aws-ecs-task.arn
  lifecycle {
    ignore_changes = [desired_count, task_definition]
  }
  load_balancer {
    container_name   = "${var.image_name}"
    container_port   = 80
    target_group_arn = var.lb_target_group_arn
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