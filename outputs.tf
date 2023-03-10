output "vpc_id" {
  value = aws_vpc.peer.id
}

output "subnets" {
    value = aws_vpc.peer.subnets
}