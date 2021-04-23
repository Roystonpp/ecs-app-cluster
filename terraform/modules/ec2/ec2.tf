resource "aws_instance" "webapp" {
  ami           = var.ami
  count         = var.ec2_count
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = var.subnet_id
  user_data     = file("../modules/ec2/userdata.sh")

  associate_public_ip_address = var.public_ip

  tags = {
    Name = var.name
  }
}