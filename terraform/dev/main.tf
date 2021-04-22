provider "aws" {
  region = "eu-west-1"
}

module "vpc" {
  source = "../modules/vpc"

  cidr_block   = "192.168.0.0/26"
  name         = "devops-vpc"
  private_cidr = "192.168.1.0/28"
  public_cidr  = "192.168.2.0/28"
  vpc          = true
}


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