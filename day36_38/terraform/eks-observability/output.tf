output "bastion_vm_public_ip" {
  value       = aws_instance.bastion.public_ip
  description = "The bastion vm public ip"
}
