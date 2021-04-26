resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_hostnames = var.enable_dns
  enable_dns_support   = var.enable_support

  tags = {
    Name = var.name
  }
}

resource "aws_subnet" "public" {
  cidr_block = var.public_cidr
  vpc_id     = aws_vpc.vpc.id
#  availability_zone = var.az_zone_a
}

//resource "aws_subnet" "public_b" {
//  cidr_block = var.public_cidr_b
//  vpc_id     = aws_vpc.vpc.id
//#  availability_zone = var.az_zone_b
//}

resource "aws_subnet" "private" {
  cidr_block = var.private_cidr
  vpc_id     = aws_vpc.vpc.id
#  availability_zone = var.az_zone_a
}

//resource "aws_subnet" "private_b" {
//  cidr_block = var.private_cidr_b
//  vpc_id     = aws_vpc.vpc.id
//#  availability_zone = var.az_zone_b
//}

resource "aws_eip" "eip" {
  vpc        = var.eip_vpc
  depends_on = [aws_internet_gateway.igw]
}
//
//resource "aws_eip" "eip_b" {
//  vpc       = var.eip_vpc
//  depends_on = [aws_internet_gateway.igw]
//}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public.id
  depends_on    = [aws_eip.eip]
}
//
//resource "aws_nat_gateway" "ngw_b" {
//  allocation_id = aws_eip.eip_b.id
//  subnet_id     = aws_subnet.public_b.id
//  depends_on    = [aws_eip.eip_b]
//}

resource "aws_route_table" "public_rtb" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "devops public route table"
  }
}

resource "aws_route_table" "private_rtb" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw.id
  }

  tags = {
    Name = "devops private route table"
  }
}

//resource "aws_route_table" "private_rtb_b" {
//  vpc_id = aws_vpc.vpc.id
//
//  route {
//    cidr_block = "0.0.0.0/0"
//    nat_gateway_id = aws_nat_gateway.ngw_b.id
//  }
//
//  tags = {
//    Name = "devops private route table b"
//  }
//}

resource "aws_route_table_association" "public" {
  subnet_id = aws_subnet.public.id
  route_table_id = aws_route_table.public_rtb.id
}

//resource "aws_route_table_association" "public_b" {
//  subnet_id = aws_subnet.public_b.id
//  route_table_id = aws_route_table.public_rtb.id
//}

resource "aws_route_table_association" "private" {
  subnet_id = aws_subnet.private.id
  route_table_id = aws_route_table.private_rtb.id
}
//
//resource "aws_route_table_association" "private_b" {
//  subnet_id = aws_subnet.private_b.id
//  route_table_id = aws_route_table.private_rtb_b.id
//}

resource "aws_security_group" "lb-sg" {
  name   = var.lb_sgname
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = -1
    to_port   = -1
    protocol  = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}