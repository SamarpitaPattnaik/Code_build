output "instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.main.id
}

output "public_ip" {
  description = "EC2 Public IP Address"
  value       = aws_instance.main.public_ip
}

output "private_ip" {
  description = "EC2 Private IP Address"
  value       = aws_instance.main.private_ip
}

output "security_group_id" {
  description = "Security Group ID attached to EC2"
  value       = aws_security_group.ec2_sg.id
}
