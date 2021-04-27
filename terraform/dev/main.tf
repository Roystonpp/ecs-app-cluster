provider "aws" {
  region = "eu-west-1"
}

# VPC Module
module "vpc" {
  source = "../modules/vpc"

  name         = "devops-vpc"
  #az_zone_a    = "eu-west-1a"
  #az_zone_b    = "eu-west-1b"
  vpc_cidr_block = "192.168.0.0/26"
  public_cidr    = "192.168.0.0/28"
  private_cidr   = "192.168.0.16/28"
  #public_cidr_b  = "192.168.0.32/28"
  #private_cidr_b = "192.168.0.48/28"
  eip_vpc        = true
  lb_sgname     = "elb-security-group"
  #instance_sg   = "instance-security-group"
  enable_dns     = true
  enable_support = true
}

# ECS Module
module "ecs" {
  source = "../modules/ecs"

  cluster_name = "App-cluster"
  family       = "service"
  service_name = "devops-ecs-service"
  launch_type  = "FARGATE"
  desired_count  = 1
  fargate_cpu    = 1024
  fargate_memory = 2048
  assign_public_ip  = true
  public_subnet_a_id = module.vpc.public_subnet_id
  network_mode    = "awsvpc"
  vpc_id          = module.vpc.vpc_id
  log_group_name  = "pythonapp-logs"
  log_stream_name = "awslogs-pythonapp"
}

//module "ec2" {
//  source = "../modules/ec2"
//
//  ami       = "ami-00e64569efacb226a"
//  name      = "web-app"
//  ec2_count = 1
//  public_ip = true
//  key_name  = "ops-test-key"
//  subnet_id = module.vpc.public_subnet_id
//  instance_type = "t2.micro"
//  iam_role_name = "ecr_push_role"
//  profile_name  = "ecr_push_profile"
//  depends_on    = [module.ecr]
//  vpc_id        = module.vpc.vpc_id
//  instance_sg   = "ec2_sg"
//}

//module "ecr" {
//  source = "../modules/ecr"
//
//  name = "python-app-ecr"
//  image_tag_mutability = "MUTABLE"
//  depends_on = [module.vpc]
//}

//module "asg" {
//  source = "../modules/asg"
//
//  min_size = 0
//  max_size = 2
//  image_id = "ami-06178cf087598769c"
//  strategy = "cluster"
//  plg_name = "asg-placement-group"
//  name_prefix = "asg-template"
//  instance_type = "t2.micro"
//  desired_capacity = 1
//}