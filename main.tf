terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "us-east-2"
}
resource "aws_instance" "webserver" {
  # Ubuntu Server 18.04 LTS (HVM), SSD Volume Type in us-east-2
  ami                    = "ami-0c55b159cbfafe1f0"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World\n sample webserver" > index.html
              nohup busybox httpd -f -p "${var.server_port}" &
              EOF

  tags = {
    Name = "sample-webserver"
  }
}
resource "aws_security_group" "instance" {
  name = "sample-webserver-instance"

  # Inbound HTTP from anywhere
  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
