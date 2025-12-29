resource "aws_vpc" "project" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name = "project-vpc"
  }
}

resource "aws_subnet" "project-pub-1" {
  vpc_id                  = aws_vpc.project.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = var.ZONE1
  tags = {
    Name = "project-pub-1"
  }
}

resource "aws_subnet" "project-pub-2" {
  vpc_id                  = aws_vpc.project.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = var.ZONE2
  tags = {
    Name = "project-pub-2"
  }
}


resource "aws_subnet" "project-priv-1" {
  vpc_id                  = aws_vpc.project.id
  cidr_block              = "10.0.4.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = var.ZONE1
  tags = {
    Name = "project-priv-1"
  }
}


resource "aws_subnet" "project-priv-2" {
  vpc_id                  = aws_vpc.project.id
  cidr_block              = "10.0.5.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = var.ZONE2
  tags = {
    Name = "project-priv-2"
  }
}


resource "aws_internet_gateway" "project-IGW" {
  vpc_id = aws_vpc.project.id
  tags = {
    Name = "project-IGW"
  }
}

resource "aws_route_table" "project-pub-RT" {
  vpc_id = aws_vpc.project.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.project-IGW.id
  }

  tags = {
    Name = "project-pub-RT"
  }
}


resource "aws_route_table_association" "project-pub-1a" {
  subnet_id      = aws_subnet.project-pub-1.id
  route_table_id = aws_route_table.project-pub-RT.id
}

resource "aws_route_table_association" "project-pub-2a" {
  subnet_id      = aws_subnet.project-pub-2.id
  route_table_id = aws_route_table.project-pub-RT.id
}

