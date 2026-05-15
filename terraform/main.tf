resource "aws_key_pair" "deploy_key" {

  key_name   = "devsecops-deploy-key"

  public_key = file("../terraform-keys/devsecops-deploy-key.pub")
}

resource "aws_security_group" "deploy_sg" {

  name        = "enterprise-devsecops-deploy-sg"

  description = "Security Group for Deployment EC2"

  ingress {

    description = "SSH Access"

    from_port   = 22

    to_port     = 22

    protocol    = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {

    description = "Development Environment"

    from_port   = 3000

    to_port     = 3000

    protocol    = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {

    description = "Staging Environment"

    from_port   = 3001

    to_port     = 3001

    protocol    = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {

    description = "Production Environment"

    from_port   = 3002

    to_port     = 3002

    protocol    = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {

    description = "HTTPS Outbound"

    from_port   = 443

    to_port     = 443

    protocol    = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {

    Name = "Enterprise-DevSecOps-Deploy-SG"
  }
}

resource "aws_instance" "deploy_server" {

  ami           = "ami-0e86e20dae9224db8"

  instance_type = "t3.micro"

  key_name = aws_key_pair.deploy_key.key_name

  vpc_security_group_ids = [
    aws_security_group.deploy_sg.id
  ]

  associate_public_ip_address = true

  tags = {

    Name = "Enterprise-DevSecOps-Deploy-Server"
  }
}
