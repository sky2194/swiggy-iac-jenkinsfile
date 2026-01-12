resource "aws_security_group" "Swiggy-SG" {
  name        = "Swiggy-SG"
  description = "Open 22,443,80,8080,9000"

 # Define a single ingress rule to allow traffic on all specified ports
  
  ingress = [
    for port in [22, 80, 443, 8080, 9000, 3000] : {
      description      = "TLS from VPC"
      from_port        = port
      to_port          = port
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name = "Swiggy-SG"
  }
  
}

resource "aws_instance" "Swiggy-Instance" {


  ami           = "ami-053b0d53c279acc90"  # Unbuntu Server 22.04 LTS (HVM), SSD Volume Type
  instance_type = "t2.large"
  key_name      = "Swiggy"     # Replace with your key pair name
  vpc_security_group_ids = [aws_security_group.Swiggy-SG.id]
  user_data              = templatefile("./resource.sh", {})


  tags = {
    Name = "Swiggy"
    }

  root_block_device {
    volume_size = 30
  }
}

