# ALB Security Group (Traffic Internet -> ALB)
resource "aws_security_group" "load-balancer" {
  name        = "load_balancer_security_group"
  description = "Controls access to the ALB"
  vpc_id      = aws_vpc.benjaminfiche-vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
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
    name = "BenjaminFiche-sg-loadbalancer"
  }
}

# Instance Security group (traffic ALB -> EC2, ssh -> EC2)
resource "aws_security_group" "ec2" {
  name        = "ec2_security_group"
  description = "Allows inbound access from the ALB only"
  vpc_id      = aws_vpc.benjaminfiche-vpc.id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.load-balancer.id]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "MYSQL"
    from_port   = 3306
    to_port     = 3306
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
    name = "BenjaminFiche-sg-ec2"
  }
}

resource "aws_security_group" "RDS_allow_rule" {
  vpc_id = aws_vpc.benjaminfiche-vpc.id

  ingress = [
    {
      description = "MYSQL"
      from_port       = 3306
      to_port         = 3306
      protocol        = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      self = false
      security_groups = ["${aws_security_group.ec2.id}"]
    }
  ]

  egress = [
    {
      description = "for all outgoing traffic"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      cidr_blocks = ["0.0.0.0/0"]
      security_groups = ["${aws_security_group.ec2.id}"]
      self = false
    }
  ]

  tags = {
    name = "BenjaminFiche-sg-rds"
  }
}