#=================== Bastion Servre Security Group==========================
resource "aws_security_group" "stopnshop-bastionservre-sg" {
  name   = "stopnshop-bastionservre-sg"
  vpc_id = aws_vpc.stopnshop-prod-vpc.id

  dynamic "ingress" {
    for_each = var.bastionserverports
    iterator = port
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "TLS Traffic from public network"
    }

  }
  dynamic "egress" {
    for_each = var.egressports
    iterator = port
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "TLS Traffic to public network"
    }
  }
  tags = {
    Name        = "stopnshop-bastionservre-sg"
    Environment = "production"
    Project     = "stopnshop"
    Owner       = "kthadikaran@gmail.com"
  }
}

#=================== Application Load Balancer Security Group==========================
resource "aws_security_group" "stopnshop-alb-sg" {
  name   = "stopnshop-alb-sg"
  vpc_id = aws_vpc.stopnshop-prod-vpc.id

  dynamic "ingress" {
    for_each = var.albsgports
    iterator = port
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "TLS Traffic from public network"
    }

  }
  dynamic "egress" {
    for_each = var.egressports
    iterator = port
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "TLS Traffic to public network"
    }
  }
  tags = {
    Name        = "stopnshop-alb-sg"
    Environment = "production"
    Project     = "stopnshop"
    Owner       = "kthadikaran@gmail.com"
  }
}
#=================== Web server Security Group==========================
resource "aws_security_group" "stopnshop-webserver-sg" {
  name   = "stopnshop-webserver-sg"
  vpc_id = aws_vpc.stopnshop-prod-vpc.id

  dynamic "ingress" {
    for_each = var.webservergports
    iterator = port
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "TLS Traffic from public network"
    }

  }
  dynamic "egress" {
    for_each = var.egressports
    iterator = port
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "TLS Traffic to public network"
    }
  }
  tags = {
    Name        = "stopnshop-webserver-sg"
    Environment = "production"
    Project     = "stopnshop"
    Owner       = "kthadikaran@gmail.com"
  }
}


#=================== Application server Security Group==========================
resource "aws_security_group" "stopnshop-appserver-sg" {
  name   = "stopnshop-apperver-sg"
  vpc_id = aws_vpc.stopnshop-prod-vpc.id

  dynamic "ingress" {
    for_each = var.appervergports
    iterator = port
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "TLS Traffic from public network"
    }

  }
  dynamic "egress" {
    for_each = var.egressports
    iterator = port
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "TLS Traffic to public network"
    }
  }
  tags = {
    Name        = "stopnshop-appserver-sg"
    Environment = "production"
    Project     = "stopnshop"
    Owner       = "kthadikaran@gmail.com"
  }
}

#=================== Database Server Security Group==========================
resource "aws_security_group" "stopnshop-dbserver-sg" {
  name   = "stopnshop-dbserver-sg"
  vpc_id = aws_vpc.stopnshop-prod-vpc.id

  dynamic "ingress" {
    for_each = var.dbservergports
    iterator = port
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "TLS Traffic from public network"
    }

  }
  dynamic "egress" {
    for_each = var.egressports
    iterator = port
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "TLS Traffic to public network"
    }
  }
  tags = {
    Name        = "stopnshop-dbserver-sg"
    Environment = "production"
    Project     = "stopnshop"
    Owner       = "kthadikaran@gmail.com"
  }
}