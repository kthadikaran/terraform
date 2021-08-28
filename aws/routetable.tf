#Add Internet gateway route on default route table
resource "aws_default_route_table" "stopnshop-prod-mrtb" {
  default_route_table_id = aws_vpc.stopnshop-prod-vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.stopnshop-prod-igw.id
  }

  tags = {
    Name        = "stopnshop-prod-mrtb"
    Environment = "production"
    Project     = "stopnshop"
    Owner       = "kthadikaran@gmail.com"
  }
}


#Create Custom Route Table
resource "aws_route_table" "stopnshop-prod-crtb" {
  vpc_id = aws_vpc.stopnshop-prod-vpc.id

  tags = {
    Name        = "stopnshop-prod-crtb"
    Environment = "production"
    Project     = "stopnshop"
    Owner       = "kthadikaran@gmail.com"
  }
}