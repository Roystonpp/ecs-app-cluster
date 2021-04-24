output "vpc_id" { value = aws_vpc.vpc.id }
output "public_subnet_id" { value = aws_subnet.public.id }
output "elb_sg_id" { value = aws_security_group.lb-sg.id }
output "private_subnet_id" { value = aws_subnet.private.id }
output "instance_sg_id" { value = aws_security_group.instance_sg.id }