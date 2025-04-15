data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "dm_sg" {
  name        = "dm-api-sg"
  description = "Security group for API"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP for DM API"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "dm-api-sg"
  }
}

resource "aws_instance" "dm_ec2" {
  ami           = "ami-084568db4383264d4"
  instance_type = "t2.micro"
  key_name      = var.key_name
  security_groups = [aws_security_group.dm_sg.name]

  user_data = templatefile("${path.module}/../../scripts/deploy-api.sh", {
    DB_HOST = var.db_host
    DB_USERNAME = var.db_username
    DB_PASSWORD = var.db_password
    DB_NAME = var.db_name
  })

  tags = {
    Name = "DM-API-Server"
  }
}
