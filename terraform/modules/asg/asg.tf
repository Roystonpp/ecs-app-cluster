resource "aws_placement_group" "pl_group" {
  name     = var.plg_name
  strategy = var.strategy
}

resource "aws_launch_template" "template" {
  name_prefix   = var.name_prefix
  image_id      = var.image_id
  instance_type = var.instance_type
}

resource "aws_autoscaling_group" "asg" {
  max_size = var.max_size
  min_size = var.min_size
  desired_capacity = var.desired_capacity
  placement_group  = aws_placement_group.pl_group.id
}