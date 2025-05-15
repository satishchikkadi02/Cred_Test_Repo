provider "aws" {
  region = "us-east-1"
}

# Create an S3 bucket with private access
resource "aws_s3_bucket" "private_bucket" {
  bucket = "my-private-bucket-${random_string.suffix.result}"
  acl    = "private"

  tags = {
    Name        = "PrivateBucket"
    Environment = "Dev"
  }
}

resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

# Create a security group for the EC2 instance
resource "aws_security_group" "ec2_sg" {
  name_prefix = "ec2-sg-"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "EC2SecurityGroup"
  }
}

# Create an EC2 instance
resource "aws_instance" "ec2_instance" {
  ami           = "ami-0c55b159cbfafe1f0" # Replace with a valid AMI ID for your region
  instance_type = "t2.micro"

  security_groups = [aws_security_group.ec2_sg.name]

  tags = {
    Name = "MyEC2Instance"
  }
}