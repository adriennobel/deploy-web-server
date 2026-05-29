 # security group
resource "aws_security_group" "project1_sg" {
  name        = "project1-SG"
  description = "Allow SSH and HTTP traffic"
  vpc_id     = aws_vpc.apache_deployment.id
  
  tags = {
    Name = "project1-SG"
  }
}

# Ingress Rules
resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.project1_sg.id
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "10.0.0.0/16"
  description       = "Allow HTTP"
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.project1_sg.id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = "10.0.0.0/16"
  description       = "Allow SSH"
}

# Egress Rule
resource "aws_vpc_security_group_egress_rule" "all_outbound" {
  security_group_id = aws_security_group.project1_sg.id
  ip_protocol       = "-1"
  cidr_ipv4         = "10.0.0.0/16"
}
