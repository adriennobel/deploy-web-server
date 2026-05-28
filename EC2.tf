resource "aws_key_pair" "vickydivinekey"{
  key_name   = "vickydivinekey"
  public_key = file("~/.ssh/terraform-ec2-key.pub")
}

resource "aws_instance" "project1" {
  ami                         = "ami-0c02fb55956c7d316" # Amazon Linux 2, us-east-1
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.project1_sg.id]
  key_name                    = aws_key_pair.ec2_key.vickydivinekey
  associate_public_ip_address = true

  tags = {
    Name = "project1"
  }
}