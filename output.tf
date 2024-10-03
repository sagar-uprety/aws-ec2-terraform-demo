output "instance_public_ip" {
  value = aws_instance.app_server.public_ip
  description = "value of the public IP of the EC2 instance"
}

output "vpc_id" {
  value = aws_vpc.dev_app_vpc.id
  description = "value of the VPC ID"
}