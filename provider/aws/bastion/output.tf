output "public_ip" {
    description = "Bastion EC2 public ip"
    value = element(compact(concat(aws_eip.public-server-ip.*.public_ip, list(var.undefined_value))), 0)
}

output "ssh" {
    description = "Bastion EC2 ssh command"
    value = "ssh -i ${path.module}/${var.ssh_private_key_path} ec2-user@${element(compact(concat(aws_eip.public-server-ip.*.public_dns, list(var.undefined_value))), 0)}"
}