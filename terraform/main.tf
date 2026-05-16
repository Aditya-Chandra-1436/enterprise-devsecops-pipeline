resource "aws_security_group" "deploy_sg" {

  name        = "enterprise-devsecops-deploy-sg"

  description = "Security group for DevSecOps deployment server"

  ingress {

    description = "SSH Access"

    from_port   = 22
    to_port     = 22
    protocol    = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {

    description = "Application Access"

    from_port   = 3000
    to_port     = 3002
    protocol    = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {

    description = "Outbound Access"

    from_port   = 0
    to_port     = 0
    protocol    = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {

    Name = "Enterprise-DevSecOps-SG"
  }
}

resource "aws_key_pair" "deploy_key" {

  key_name = "enterprise-devsecops-key"

  public_key = file("keys/id_rsa.pub")
}

resource "aws_instance" "deploy_server" {

  ami = "ami-0d1b5a8c13042c939"

  instance_type = "t2.micro"

  key_name = aws_key_pair.deploy_key.key_name

  monitoring = true

  vpc_security_group_ids = [

    aws_security_group.deploy_sg.id
  ]

  metadata_options {

    http_endpoint = "enabled"

    http_tokens = "required"
  }

  root_block_device {

    encrypted = true

    volume_size = 8

    volume_type = "gp2"
  }

  user_data = file("../scripts/install-docker.sh")

  tags = {

    Name = "Enterprise-DevSecOps-Deployment-Server"
  }
}
