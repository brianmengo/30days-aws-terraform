
data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["default"]
  }
}

data "aws_subnet" "shared" {
  filter {
    name   = "tag:Name"
    values = ["Subneta"]
  }

  vpc_id = data.aws_vpc.selected.id
}

data "aws_ami" "Linux2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
 }
resource "aws_instance" "example"{
  ami       = data.aws_ami.Linux2.id
  instance_type = "t2.micro"
  subnet_id = data.aws_subnet.shared.id

}
