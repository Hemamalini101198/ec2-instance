terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      #version = "5.26.0"
    }
  }
}

provider "aws" {
  region = var.region
}


resource "tls_private_key" "pvt_key" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "aws_key_pair" "key_pair" {
  key_name   = var.key_name
  public_key = tls_private_key.pvt_key.public_key_openssh
}

#resource "local_file" "private_key" {
 # content = tls_private_key.pvt_key.private_key_pem
  #filename = var.key_name
#}

data "aws_s3_bucket" "pvt_key" {
  bucket = var.s3_bucket
}

resource "aws_s3_bucket_object" "instance_key" {
  bucket = data.aws_s3_bucket.pvt_key.bucket
  key = var.key_name  
  server_side_encryption = "AES256"
  content_type           = "text/plain"
  content                = <<EOF
private_key_pem: ${tls_private_key.pvt_key.private_key_pem}
EOF
}

/*
#upload own public key to connect with instance
resource "aws_key_pair" "pub_key" {
  key_name   = var.key_name
public_key = ""
}


resource "aws_security_group" "ec2_security_group" {
  name        = "ec2-sg"
  description = "security group for EC2 instance"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
*/
resource "aws_instance" "ec2_instance" {
  ami = var.ami_id
  instance_type = var.instance_type
  
  key_name = aws_key_pair.key_pair.key_name
  #vpc_security_group_ids = [aws_security_group.ec2_security_group.id]
  #subnet_id = 

  tags = {
    Name = var.instance_name
  }
}
