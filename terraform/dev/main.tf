provider "aws" {
  region = "eu-west-1"
}

module "vpc" {
  source = "../modules/vpc"

  cidr_block   = "192.168.0.0/26"
  name         = "devops-vpc"
  private_cidr = "192.168.0.16/28"
  public_cidr  = "192.168.0.32/28"
  vpc          = true
}

module "app" {
  source = "../modules/ec2"

  ami    = "ami-08bac620dc84221eb"
  name   = "web-app"
  ec2_count = 1
  public_ip = true
  key_name  = "ops-test-key"
  subnet_id = module.vpc.subnet_id
  instance_type = "t2.micro"
}

//module "ecr" {
//  source = "../modules/ecr"
//
//  name = "python-app-ecr"
//  image_tag_mutability = "MUTABLE"
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