#Create subnet for Application Load Balancer

resource "aws_subnet" "stopnshop-prod-alb-1a" {
  vpc_id                  = aws_vpc.stopnshop-prod-vpc.id
  cidr_block              = var.albsubnetcidrip1a
  availability_zone       = "ap-southeast-1a"
  map_public_ip_on_launch = true

  tags = {
    Name        = "stopnshop-prod-alb-1a"
    Environment = "production"
    Project     = "stopnshop"
    Owner       = "kthadikaran@gmail.com"
  }
}
#Public subnets main route table association
resource "aws_route_table_association" "rtassociate_alb1" {
  subnet_id      = aws_subnet.stopnshop-prod-alb-1a.id
  route_table_id = aws_default_route_table.stopnshop-prod-mrtb.default_route_table_id
}

resource "aws_subnet" "stopnshop-prod-alb-1b" {
  vpc_id                  = aws_vpc.stopnshop-prod-vpc.id
  cidr_block              = var.albsubnetcidrip1b
  availability_zone       = "ap-southeast-1b"
  map_public_ip_on_launch = true

  tags = {
    Name        = "stopnshop-prod-alb-1b"
    Environment = "production"
    Project     = "stopnshop"
    Owner       = "kthadikaran@gmail.com"
  }
}
#Public subnets main route table association
resource "aws_route_table_association" "rtassociate_alb2" {
  subnet_id      = aws_subnet.stopnshop-prod-alb-1b.id
  route_table_id = aws_default_route_table.stopnshop-prod-mrtb.default_route_table_id
}

#Create subnet for Web server
resource "aws_subnet" "stopnshop-prod-websubnet-1a" {
  vpc_id            = aws_vpc.stopnshop-prod-vpc.id
  cidr_block        = var.websubnetcidrip1a
  availability_zone = "ap-southeast-1a"

  tags = {
    Name        = "stopnshop-prod-websubnet-1a"
    Environment = "production"
    Project     = "stopnshop"
    Owner       = "kthadikaran@gmail.com"
  }
}
#Private subnets custom route Table Association
resource "aws_route_table_association" "rtassociate_w1a" {
  subnet_id      = aws_subnet.stopnshop-prod-websubnet-1a.id
  route_table_id = aws_route_table.stopnshop-prod-crtb.id
}


resource "aws_subnet" "stopnshop-prod-websubnet-1b" {
  vpc_id            = aws_vpc.stopnshop-prod-vpc.id
  cidr_block        = var.websubnetcidrip1b
  availability_zone = "ap-southeast-1b"

  tags = {
    Name        = "stopnshop-prod-websubnet-1b"
    Environment = "production"
    Project     = "stopnshop"
    Owner       = "kthadikaran@gmail.com"
  }
}

#Private subnets custom route Table Association
resource "aws_route_table_association" "rtassociate_w1b" {
  subnet_id      = aws_subnet.stopnshop-prod-websubnet-1b.id
  route_table_id = aws_route_table.stopnshop-prod-crtb.id
}

#Create subnet for application server
resource "aws_subnet" "stopnshop-prod-appsubnet1a" {
  vpc_id            = aws_vpc.stopnshop-prod-vpc.id
  cidr_block        = var.appsubnetcidrip1a
  availability_zone = "ap-southeast-1a"

  tags = {
    Name        = "stopnshop-prod-appsubnet1a"
    Environment = "production"
    Project     = "stopnshop"
    Owner       = "kthadikaran@gmail.com"
  }
}

#Private subnets custom route Table Association
resource "aws_route_table_association" "rtassociate_a1a" {
  subnet_id      = aws_subnet.stopnshop-prod-appsubnet1a.id
  route_table_id = aws_route_table.stopnshop-prod-crtb.id
}

resource "aws_subnet" "stopnshop-prod-appsubnet1b" {
  vpc_id            = aws_vpc.stopnshop-prod-vpc.id
  cidr_block        = var.appsubnetcidrip1b
  availability_zone = "ap-southeast-1b"

  tags = {
    Name        = "stopnshop-prod-appsubnet1b"
    Environment = "production"
    Project     = "stopnshop"
    Owner       = "kthadikaran@gmail.com"
  }
}
#Private subnets custom route Table Association
resource "aws_route_table_association" "rtassociate_a1b" {
  subnet_id      = aws_subnet.stopnshop-prod-appsubnet1b.id
  route_table_id = aws_route_table.stopnshop-prod-crtb.id
}


#Create subnet for databasr server
resource "aws_subnet" "stopnshop-prod-dbsubnet1a" {
  vpc_id            = aws_vpc.stopnshop-prod-vpc.id
  cidr_block        = var.dbsubnetcidrip1a
  availability_zone = "ap-southeast-1a"

  tags = {
    Name        = "stopnshop-prod-dbsubnet1a"
    Environment = "production"
    Project     = "stopnshop"
    Owner       = "kthadikaran@gmail.com"
  }
}

#Private subnets custom route Table Association
resource "aws_route_table_association" "rtassociated1a" {
  subnet_id      = aws_subnet.stopnshop-prod-dbsubnet1a.id
  route_table_id = aws_route_table.stopnshop-prod-crtb.id
}

resource "aws_subnet" "stopnshop-prod-dbsubnet1b" {
  vpc_id            = aws_vpc.stopnshop-prod-vpc.id
  cidr_block        = var.dbsubnetcidrip1b
  availability_zone = "ap-southeast-1b"

  tags = {
    Name        = "stopnshop-prod-dbsubnet1b"
    Environment = "production"
    Project     = "stopnshop"
    Owner       = "kthadikaran@gmail.com"
  }
}
#Private subnets custom route Table Association
resource "aws_route_table_association" "rtassociated1b" {
  subnet_id      = aws_subnet.stopnshop-prod-dbsubnet1b.id
  route_table_id = aws_route_table.stopnshop-prod-crtb.id
}