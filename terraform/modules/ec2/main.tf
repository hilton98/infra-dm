resource "aws_instance" "dm_ec2" {
  ami                         = "ami-084568db4383264d4" 
  instance_type               = "t2.micro"             
  subnet_id                   = "${var.subnet_id}"
  vpc_security_group_ids      = ["${var.vpc_id}"]  
  key_name                    = "${var.key_name}"
  associate_public_ip_address = true

  tags = {
    Name = "dm-instance"
  }
}
