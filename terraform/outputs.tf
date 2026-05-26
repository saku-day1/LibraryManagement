output "ec2_public_ip" {
  description = "EC2 instance public IP address"
  value       = aws_instance.main.public_ip
}

output "ec2_public_dns" {
  description = "EC2 instance public DNS"
  value       = aws_instance.main.public_dns
}

output "rds_endpoint" {
  description = "RDS instance endpoint (host only, no port)"
  value       = aws_db_instance.main.address
}

output "ssh_command" {
  description = "SSH command to connect to EC2"
  value       = "ssh -i ~/.ssh/id_rsa ec2-user@${aws_instance.main.public_ip}"
}

output "app_url" {
  description = "Application URL"
  value       = "http://${aws_instance.main.public_ip}"
}
