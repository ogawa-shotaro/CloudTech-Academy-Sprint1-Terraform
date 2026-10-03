output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.sprint1_terra_vpc.id
}

output "public_subnet_id" {
  description = "パブリックサブネットID"
  value       = aws_subnet.sprint1_terra_public_subnet.id
}

output "private_subnet_id" {
  description = "プライベートサブネットID"
  value       = aws_subnet.sprint1_terra_private_subnet.id
}

output "web_public_ip" {
  description = "WebサーバのElastic IP"
  value       = aws_eip.sprint1_terra_web_eip.public_ip
}

output "api_private_ip" {
  description = "APIサーバのプライベートIP"
  value       = aws_instance.sprint1_terra_api_server.private_ip
}

output "nat_gateway_public_ip" {
  description = "NAT GatewayのパブリックIP"
  value       = aws_eip.sprint1_terra_nat_eip.public_ip
}
