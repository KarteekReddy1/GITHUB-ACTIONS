provider "aws" {
  region = "us-east-1"
}

# Get the default VPC
data "aws_vpc" "default" {
  default = true
}

# Get a default subnet from that VPC
data "aws_subnet" "default" {
  vpc_id = data.aws_vpc.default.id
}

# Get the default security group for the default VPC
data "aws_security_group" "default" {
  vpc_id = data.aws_vpc.default.id
  filter {
    name   = "group-name"
    values = ["default"]
  }
}

# Launch EC2 instance using the default SG
resource "aws_instance" "example" {
  ami                    = "ami-02dfbd4ff395f2a1b" # Amazon Linux 2 (us-east-1)
  instance_type          = "t2.micro"
  subnet_id              = data.aws_subnet.default.id
  vpc_security_group_ids = [data.aws_security_group.default.id]

  tags = {
    Name = "Terraform-EC2"
  }
}
