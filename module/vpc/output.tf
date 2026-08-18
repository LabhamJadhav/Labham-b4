output "vpc_id" {
  value = aws_vpc.my_vpc.id
}

output "public_subnet" {
  value = aws_subnet.public_subnet.id
}
