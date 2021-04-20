resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block

  tags = {
    Name = var.name
  }
}

resource "aws_subnet" "public" {
  cidr_block = var.public_cidr
  vpc_id     = aws_vpc.vpc.id
}

resource "aws_subnet" "private" {
  cidr_block = var.private_cidr
  vpc_id     = aws_vpc.vpc.id
}