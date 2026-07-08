resource "aws_instance" "example" {
  ami           = "ami-0ff8a91507f77f867"
  instance_type = var.allowed_instance_type[1]
  region = toList(var.allowed_region)[0]

  tags = var.tags

  lifecycle {
  create_before_destroy = true 
  prevent_destroy = true
  } 
}

resource "aws_launch_template" "app_servers" {
  image_id      = "ami-0ff8a91507f77f867"
  instance_type = var.allowed_instance_type[1]

  tag_specifications {
    resource_type = "instance"

    tags = var.tags
  }
}
#Auto Scaling Group
resource "aws_autoscaling_group" "app_asg" {
  desired_capacity     = 2
  max_size             = 5
  min_size             = 1
  vpc_zone_identifier  = [aws_subnet.example.id]
  health_check_type   = "EC2"
  launch_template {
    id      = aws_launch_template.app_servers.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "AppServer"
    propagate_at_launch = true
  }

  lifecycle{
    ignore_changes =[
      desired_capacity,
      load_balancers,]
     }
}

#Security Group
resource "aws_security_group" "app_sg" {
  name        = "app_sg"
  description = "Security group for app servers"
  vpc_id      = aws_vpc.example.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0/0"]
  }

  tags = var.tags
}

  #EC2 Instance that gets replaced when security group changes
  resource "aws_instance" "app_with_sg" {
    ami           = "ami-0ff8a91507f77f867"
    instance_type = var.allowed_instance_type[1]
    vpc_security_group_ids = [aws_security_group.app_sg.id]
    tags = var.tags
    
    lifecycle {
      replace_triggered_by = [ aws_security_group.app_sg.id ]
    }
  }