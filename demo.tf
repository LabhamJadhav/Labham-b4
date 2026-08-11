provider "aws" {
    region = "us-east-1"
}
resource "aws_instance" "my-instance1" {
    ami = "ami-0bdc7d025135d7b49"
    instance_type = "t3.micro"
    security_groups = ["sg-08bfefd91af5b73d1", "sg-0b38b698bbfdaf548"]
}

 ---------
 
provider "aws" {
    region = "ap-south-1"

}
resource "aws_instance" "my-inst2" {
    ami = "ami-01a00762f46d584a1"
    instance_type = "t3.micro"
    security_groups = ["sg-044c77041f14f0e45"]
}


------------

provider "aws" {
  region = "ap-south-1"
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "labham-bucket-12345"

  tags = {
    Name = "MyS3Bucket"
  }
}


-----------

provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "my_ec2" {
  ami                    = "ami-01a00762f46d584a1"
  instance_type          = "t3.micro"
  key_name               = "my-keypair"
  vpc_security_group_ids = ["sg-044c77041f14f0e45"]

  tags = {
    Name = "MyEC2"
  }
}


------