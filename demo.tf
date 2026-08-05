provider "aws" {
    region = "us-east-1"
}
resource "aws_instance" "my-instance1" {
    ami = "ami-0bdc7d025135d7b49"
    instance_type = "t3.micro"
    security_groups = ["sg-08bfefd91af5b73d1", "sg-0b38b698bbfdaf548"]
}