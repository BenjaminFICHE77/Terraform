# VPC
resource "aws_vpc" "benjaminfiche-vpc" {
  cidr_block           = var.vpc_cidr
  # enable_dns_support   = true
  # enable_dns_hostnames = true
  tags = {
    Name = "benjaminfiche-vpc"
  }
}

# Public subnetss
resource "aws_subnet" "public-subnet-1" { 
  tags = {
    Name = "public-benjaminfiche-subnet-1"
  }
  cidr_block        = var.public_subnet_1_cidr
  vpc_id            = aws_vpc.benjaminfiche-vpc.id
  availability_zone = var.availability_zones[0]
}
resource "aws_subnet" "public-subnet-2" { 
  tags = {
    Name = "public-benjaminfiche-subnet-2"
  }
  cidr_block        = var.public_subnet_2_cidr
  vpc_id            = aws_vpc.benjaminfiche-vpc.id
  availability_zone = var.availability_zones[1]
}

# Private subnets
resource "aws_subnet" "private-subnet-1" {
  tags = {
    Name = "private-benjaminfiche-subnet-1"
  }
  cidr_block        = var.private_subnet_1_cidr
  vpc_id            = aws_vpc.benjaminfiche-vpc.id
  availability_zone = var.availability_zones[0]
}
resource "aws_subnet" "private-subnet-2" {
  tags = {
    Name = "private-benjaminfiche-subnet-2"
  }
  cidr_block        = var.private_subnet_2_cidr
  vpc_id            = aws_vpc.benjaminfiche-vpc.id
  availability_zone = var.availability_zones[1]
}

# Internet Gateway for the public subnet
resource "aws_internet_gateway" "benjaminfiche-igw" {
  tags = {
    Name = "benjaminfiche-igw"
  }
  vpc_id = aws_vpc.benjaminfiche-vpc.id
}

# NAT Gateway for the public subnet
resource "aws_eip" "eip-1" {
    domain = "vpc"
  # associate_with_private_ip = "10.0.0.5"
  depends_on                = [aws_internet_gateway.benjaminfiche-igw]
}
resource "aws_nat_gateway" "benjaminfiche-ngw-1" {
  allocation_id = aws_eip.eip-1.id
  subnet_id     = aws_subnet.public-subnet-1.id

  tags = {
    Name = "benjaminfiche-ngw-1"
  }
  depends_on = [aws_eip.eip-1]
}

resource "aws_eip" "eip-2" {
    domain = "vpc"
  # associate_with_private_ip = "10.0.0.5"
  # depends_on                = [aws_internet_gateway.benjaminfiche-igw]
}
resource "aws_nat_gateway" "benjaminfiche-ngw-2" {
  allocation_id = aws_eip.eip-2.id
  subnet_id     = aws_subnet.public-subnet-2.id

  tags = {
    Name = "benjaminfiche-ngw-2"
  }
  depends_on = [aws_eip.eip-2]
}


# Route tables for the subnets
resource "aws_route_table" "public-route-table-1" {
  vpc_id = aws_vpc.benjaminfiche-vpc.id
  tags = {
    Name = "public-benjaminfiche-route-table-1"
  }
}

resource "aws_route_table" "public-route-table-2" {
  vpc_id = aws_vpc.benjaminfiche-vpc.id
  tags = {
    Name = "public-benjaminfiche-route-table-2"
  }
}

resource "aws_route_table" "private-route-table-1" {
  vpc_id = aws_vpc.benjaminfiche-vpc.id
  tags = {
    Name = "private-benjaminfiche-route-table-1"
  }
}

resource "aws_route_table" "private-route-table-2" {
  vpc_id = aws_vpc.benjaminfiche-vpc.id
  tags = {
    Name = "private-benjaminfiche-route-table-2"
  }
}

# Route the public subnet traffic through the Internet Gateway
resource "aws_route" "public-internet-igw-route-1" {
  route_table_id         = aws_route_table.public-route-table-1.id
  gateway_id             = aws_internet_gateway.benjaminfiche-igw.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route" "public-internet-igw-route-2" {
  route_table_id         = aws_route_table.public-route-table-2.id
  gateway_id             = aws_internet_gateway.benjaminfiche-igw.id
  destination_cidr_block = "0.0.0.0/0"
}

# Route NAT Gateway
resource "aws_route" "nat-ngw-route-1" {
  route_table_id         = aws_route_table.private-route-table-1.id
  nat_gateway_id         = aws_nat_gateway.benjaminfiche-ngw-1.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route" "nat-ngw-route-2" {
  route_table_id         = aws_route_table.private-route-table-2.id
  nat_gateway_id         = aws_nat_gateway.benjaminfiche-ngw-2.id
  destination_cidr_block = "0.0.0.0/0"
}

# Associate the newly created route tables to the subnets
resource "aws_route_table_association" "public-route-1-association" {
  route_table_id = aws_route_table.public-route-table-1.id
  subnet_id      = aws_subnet.public-subnet-1.id
}
resource "aws_route_table_association" "public-route-2-association" {
  route_table_id = aws_route_table.public-route-table-2.id
  subnet_id      = aws_subnet.public-subnet-2.id
}
resource "aws_route_table_association" "private-route-1-association" {
  route_table_id = aws_route_table.private-route-table-1.id
  subnet_id      = aws_subnet.private-subnet-1.id
}
resource "aws_route_table_association" "private-route-2-association" {
  route_table_id = aws_route_table.private-route-table-2.id
  subnet_id      = aws_subnet.private-subnet-2.id
}