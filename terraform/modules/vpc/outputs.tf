output "vpc_id" { value = aws_vpc.vpc.id }
output "public_subnet_id" { value = aws_subnet.public.id }
#output "public_subnet_b_id" { value = aws_subnet.public_b.id }
output "elb_sg_id" { value = aws_security_group.lb-sg.id }
output "private_subnet_id" { value = aws_subnet.private.id }
output "eip" { value = aws_eip.eip.public_ip }
#output "private_subnet_b_id" { value = aws_subnet.private_b }