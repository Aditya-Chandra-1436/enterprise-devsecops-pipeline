output "deployment_server_ip" {
  value = aws_instance.deploy_server.public_ip
}
