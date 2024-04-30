#VPC-MODULE

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "192.168.0.0/16"

  azs             = data.aws_availability_zones.az.names
 # private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = var.public_subnets

  # enable_nat_gateway = true
  # single_nat_gateway = true
map_public_ip_on_launch = true
  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}


 
#SG-SONAR
resource "aws_security_group" "sonar_sg_1" {
  # name   = var.sgname_sonar # define this variable
  vpc_id = module.vpc.vpc_id # define this variable

  # Ingress rules
  dynamic "ingress" {
    for_each = var.port_sonar # define this variable
    content {
      description = "TLS from VPC"
      from_port   = ingress.value #ingress.value-gave value from (ingress) meaning dynamic block name and (value) taken from for_each = var.port   
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  # Egress rule
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.sg-tag # define this variable
  }
}


#SG-JENKINS
resource "aws_security_group" "jenkins_sg" {
  name   = var.sgname_sonar # define this variable
  vpc_id = module.vpc.vpc_id # define this variable

  # Ingress rules
  dynamic "ingress" {
    for_each = var.port_jenkins # define this variable
    content {
      description = "TLS from VPC"
      from_port   = ingress.value #ingress.value-gave value from (ingress) meaning dynamic block name and (value) taken from for_each = var.port   
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  # Egress rule
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.sg-tag_sonar # define this variable
  }
}



