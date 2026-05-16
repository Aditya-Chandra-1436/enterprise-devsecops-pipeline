resource "aws_security_group" "deploy_sg" {
  name = "enterprise-devsecops-deploy-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3002
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
    Name = "Enterprise-DevSecOps-SG"
  }
}

resource "aws_key_pair" "deploy_key" {
  key_name   = "enterprise-devsecops-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "deploy_server" {
  ami           = "ami-0d1b5a8c13042c939"
  instance_type = "t2.micro"

  key_name = aws_key_pair.deploy_key.key_name

  vpc_security_group_ids = [
    aws_security_group.deploy_sg.id
  ]

  user_data = file("../scripts/install-docker.sh")

  tags = {
    Name = "Enterprise-DevSecOps-Deployment-Server"
  }
}
