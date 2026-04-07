provider "aws" {
  region = "us-east-1"
}
data "aws_vpc" "default" {
  default = true
}
data "aws_subnet" "default" {
  vpc_id = data.aws_vpc.default.id
}
resource "aws_security_group" "sg_4" {
  name        = "allow_ssh_4"
  description = "Allow SSH inbound traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Demo only, restrict in production
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "example" {
  ami                    = "ami-02dfbd4ff395f2a1b" # Amazon Linux 2 (us-east-1)
  instance_type          = "t2.micro"
  subnet_id              = data.aws_subnet.default.id
  vpc_security_group_ids = [aws_security_group.sg_4.id]

  tags = {
    Name = "Terraform-EC2"
  }
}








