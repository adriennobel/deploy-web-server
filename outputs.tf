output "ec2_public_ip" {
  description = "Public IP of EC2 instance 'project1'"
  value       = aws_instance.project1.public_ip
}

output "ec2_public_dns" {
  description = "Public DNS name of EC2 instance 'project1'"
  value       = aws_instance.project1.public_dns
}
