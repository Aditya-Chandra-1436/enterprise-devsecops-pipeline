resource "random_id" "suffix" {

  byte_length = 4
}

##############################################################
# SECURITY GROUP
##############################################################

resource "aws_security_group" "deploy_sg" {

  name = "enterprise-auto-devsecops-sg-${random_id.suffix.hex}"

  description = "Automated DevSecOps Security Group"

  ingress {

    description = "SSH Access"

    from_port   = 22
    to_port     = 22
    protocol    = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {

    description = "Dev Environment"

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

    description = "Outbound Internet Access"

    from_port   = 0
    to_port     = 0
    protocol    = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {

    Name = "Enterprise-Automated-DevSecOps-SG"
  }
}

##############################################################
# KEY PAIR
##############################################################

resource "aws_key_pair" "deploy_key" {

  key_name = "enterprise-auto-devsecops-key-${random_id.suffix.hex}"

  public_key = file("keys/id_rsa.pub")
}

##############################################################
# EC2 INSTANCE
##############################################################

resource "aws_instance" "deploy_server" {

  ami = "ami-0d1b5a8c13042c939"

  instance_type = "t3.micro"

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

    Name = "Enterprise-Automated-Deployment-Server"
  }
}
