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

# security group
resource "aws_security_group" "security_group1_june" {
  name = "security_group1_june"
  description = "Allow SSH and HTTP traffic"
  vpc_id     = aws_vpc.apache_deployment.id
  
  tags = {
    Name = "security_group1_june"
  }
}

# Ingress Rules
resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group1_june.id
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "10.0.0.0/16"
  description       = "Allow HTTP"
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group1_june.id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = "10.0.0.0/16"
  description       = "Allow SSH"
}

# Egress Rule
resource "aws_vpc_security_group_egress_rule" "all_outbound" {
  security_group_id = aws_security_group1_june.id
  ip_protocol       = "-1"
  cidr_ipv4         = "10.0.0.0/16"
}
resource "aws_vpc_security_group_egress_rule" "all_outbound" {
  security_group_id = aws_security_group1_june.id
  ip_protocol       = "-1"
  cidr_ipv4         = "10.0.0.0/16"
}

# Key Pair
resource "aws_key_pair" "zazatatie_key"{
  key_name   = "zazatatie_key"
  public_key = file("~/.ssh/id_rsa.pub")
}
# EC2 Instance
resource "aws_instance" "aws_security_group1_june" { 
  ami                    = "ami-0c02fb55956c7d316"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group1_june.id]
  key_name               = aws_key_pair.zazatatie_key

  associate_public_ip_address = true

  tags = {}
    Name = "security_group1_june" 
}
