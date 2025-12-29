output "instance_id" {
  description = "AMI ID of Ubuntu instance"
  value       = data.aws_ami.amiID.id
}

output "WebPublicIP" {
  description = "AMI ID of Ubuntu instance"
  value       = aws_instance.web.public_ip
}

output "WebPrivateIP" {
  description = "AMI ID of Ubuntu instance"
  value       = aws_instance.web.private_ip
}