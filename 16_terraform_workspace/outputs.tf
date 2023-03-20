output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.app_server.public_ip
}

output "app_server_ami" {
  description = "ID of the EC2 instance AMI"
  value       = data.aws_ami.amazon_linux_ami
}