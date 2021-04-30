output "ami" {
  value = data.aws_ami.ubuntu.id
}

output "public_ip" {
  value = aws_eip.rancher_ip.public_ip
}