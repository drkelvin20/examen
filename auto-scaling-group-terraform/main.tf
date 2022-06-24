terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}


resource "aws_launch_template" "foo" {
  name = "LT-KELVIN-TAREA.o"
  description = "Template creado para tarea"
  image_id = "ami-0022f774911c1d690"
  instance_type = "t2.micro"
  tags = {
    "ESTUDIANTE" = "KELVIN"
    "NAME" = "KELVIN"
  }
  key_name = "Llava-Daniel"
  
  vpc_security_group_ids = ["sg-04beabb75f4b4d46b"]
  user_data = "${filebase64("userdata.sh")}"
}

resource "aws_autoscaling_group" "bar" {
  name = "AG-KELVIN-TERRAFORM"
  availability_zones = ["us-east-1a"]
  desired_capacity = 3
  max_size = 5
  min_size = 1

  launch_template {
    id = aws_launch_template.foo.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "INSTANCIA-KELVIN"
    propagate_at_launch = true
  } 
}


