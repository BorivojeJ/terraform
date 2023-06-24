output "ec2_global_ips" {
  value = ["${aws_instance.eu-WEST-ec2.*.public_ip}"]
}

output "instance_public_ip" {
    description = "Public IP address of the EC2 instance"
    value       = aws_instance.eu-WEST-ec2.public_ip
}