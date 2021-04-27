# Grabbing the ECR data from AWS
data "aws_ecr_repository" "ecr_repo" {
  name = "python-app-ecr"
}

# Creating a security group
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

# Specifying which policies are need for the role
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

# Specifying the service attached to the role
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

# Creating a cloudwatch log group
resource "aws_cloudwatch_log_group" "app_logs" {
  name = var.log_group_name
  retention_in_days = 1

  tags = {
    Environment = "development"
  }
}

# Attaching the stream to the cloudwatch group
resource "aws_cloudwatch_log_stream" "app_logs_stream" {
  log_group_name = aws_cloudwatch_log_group.app_logs.name
  name = var.log_stream_name
}

# Creating the ECS Cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.cluster_name
}

# Task definition for the group with container config
resource "aws_ecs_task_definition" "cluster_task" {
  family = var.family
  requires_compatibilities = [var.launch_type]
  network_mode          = var.network_mode
  cpu                   = var.fargate_cpu
  memory                = var.fargate_memory
  task_role_arn         = aws_iam_role.ecs_role.arn
  execution_role_arn    = aws_iam_role.ecs_role.arn
  container_definitions = <<DEFINITION
[
{
  "name": "cluster-task",
      "image": "${data.aws_ecr_repository.ecr_repo.repository_url}",
      "cpu": 1024,
      "memory": 2048,
      "essential": true,
  "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
          "awslogs-group": "${var.log_group_name}",
          "awslogs-region": "eu-west-1",
          "awslogs-stream-prefix": "${var.log_stream_name}"
      }
  },
  "portMappings": [
      {
          "containerPort": 8080,
          "hostPort": 8080
      }
  ]
}
]
DEFINITION
}

# Creating the service with network config
resource "aws_ecs_service" "fargate" {
  name    = var.service_name
  cluster = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.cluster_task.arn
  desired_count   = var.desired_count
  launch_type     = var.launch_type

  network_configuration {
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = var.assign_public_ip
    subnets = [var.public_subnet_a_id]
  }
}