variable "image_id" {
  default = "ami-035827357e3c7e810"
}
variable "instance_type" {
  default = "t3.micro"
}
variable "key_name" {
  default = "mum"
}
variable "project" {
  default = "terraform"
}
variable "env" {
  default = "UAT"
}
variable "vpc_id" {
  default = "vpc-01f4e997e627d366f"
}
variable "availability_zones" {
  default = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
}
variable "subnets" {
  default = ["subnet-01f62376f8d19a3b3", "subnet-0d772d03d99d73a6f", "subnet-04f54b56a3dfb5496"]
}