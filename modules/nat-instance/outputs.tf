output "nat_instance" {
    value = aws_instance.nat_instance
}

output "nat_instance_id" {
    value = aws_instance.nat_instance.id
}

# output "ssh_private_key_pem" {
#   value = tls_private_key.ssh.private_key_pem
# }

# output "ssh_public_key_pem" {
#   value = tls_private_key.ssh.public_key_pem
# }