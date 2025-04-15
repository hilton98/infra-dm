resource "aws_instance" "dm_ec2" {
  ami           = "ami-084568db4383264d4"
  instance_type = "t2.micro"
  key_name      = "${var.key_name}"
  security_groups = ["default"]
  user_data = templatefile("${path.module}/../../scripts/deploy-api.sh", {})
  tags = {
    Name = "NestJS-API-Server"
  }
}