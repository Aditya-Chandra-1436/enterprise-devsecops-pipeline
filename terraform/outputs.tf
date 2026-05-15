output "deployment_server_public_ip" {

  value = aws_instance.deploy_server.public_ip
}

output "deployment_server_id" {

  value = aws_instance.deploy_server.id
}
