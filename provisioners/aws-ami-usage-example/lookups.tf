data "aws_vpc" "default" {
  filter {
    name = "tag:Name"
    values = ["Default VPC"]
  }
}

data "aws_subnet" "default" {
  vpc_id = data.aws_vpc.default.id
  availability_zone = data.aws_availability_zone.default.id
}

data "aws_availability_zone" "default" {
  name = "eu-west-1a"
}

data "aws_ami" "ami" {
  most_recent = true
  owners      = ["123456789"] # your org id

  filter {
    name = "name"
    values = ["voronenko-dotnetbuilder19*"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name = "root-device-type"
    values = ["ebs"]
  }

}

