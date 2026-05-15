#checkov:skip=CKV2_AWS_5: Security group attached manually to existing EC2 instance

resource "aws_security_group" "devsecops_sg" {
  name        = "enterprise-devsecops-sg-v1"
  description = "Security Group for Enterprise DevSecOps Pipeline"

  ingress {
    description = "SSH Access Restricted"

    from_port   = 22
    to_port     = 22
    protocol    = "tcp"

    # REPLACE WITH YOUR ACTUAL PUBLIC IP
    cidr_blocks = ["18.224.8.10/32"]
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
    description = "HTTPS Outbound Traffic"

    from_port   = 443
    to_port     = 443
    protocol    = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Enterprise-DevSecOps-SG"
  }
}
