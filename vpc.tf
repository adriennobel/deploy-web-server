resource "aws_vpc" "apache_deployment" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id     = aws_vpc.apache_deployment.id
  cidr_block = "10.0.1.0/24"
  map_customer_owned_ip_on_launch = true

  tags = {
    Name = "Main"
  }
}

resource "aws_internet_gateway" "igwe" {
  vpc_id = aws_vpc.apache_deployment.id

  tags = {
    Name = "main"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.apache_deployment.id

  route {
    cidr_block = "10.0.1.0/24"
    gateway_id = aws_internet_gateway.igwe.id
  }

  tags = {
    Name = "Main"
  }
}

resource "aws_route_table_association" "rta" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.rt.id
}
