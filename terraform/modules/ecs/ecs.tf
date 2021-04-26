data "aws_ecr_image" "service_image" {
  repository_name = "python-app-ecr"
  image_tag       = "latest"
}

data "aws_ecr_repository" "ecr_repo" {
  name = "python-app-ecr"
}

resource "aws_security_group" "ecs_sg" {
  name = "ecs_sg"
  vpc_id = var.vpc_id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_role_policy" "access_ecr" {
  name = "access_ecr_policy"
  role = aws_iam_role.ecs_role.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sts:AssumeRole",
                "ecr:*",
                "ecs:*",
                "ecr:GetAuthorizationToken",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role" "ecs_role" {
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": [
              "ecs.amazonaws.com",
              "ecs-tasks.amazonaws.com"
          ]
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
}
EOF
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.cluster_name
}

resource "aws_ecs_task_definition" "cluster_task" {
  family = var.family
  requires_compatibilities = [var.launch_type]
  network_mode          = var.network_mode
  cpu                   = var.fargate_cpu
  memory                = var.fargate_memory
  task_role_arn         = aws_iam_role.ecs_role.arn
  execution_role_arn    = aws_iam_role.ecs_role.arn
  container_definitions = jsonencode([
    {
      name      = "cluster-task"
      image     = data.aws_ecr_repository.ecr_repo.repository_url
      cpu       = 1024
      memory    = 2048
      essential = true
      portMappings = [
        {
          containerPort = 5000
          hostPort      = 5000
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "fargate" {
  name    = var.service_name
  cluster = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.cluster_task.arn
  desired_count   = var.desired_count
  launch_type     = var.launch_type

  network_configuration {
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = var.assign_public_ip
    subnets = [var.private_subnet_id]
  }
}