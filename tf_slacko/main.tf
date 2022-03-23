data "aws_ami" "slacko-amazon" {
 most_recent      = true
 owners           = ["amazon"]

 filter {
   name   = "name"
   values = ["amzn2-ami*"]
 }

 filter {
   name   = "architecture"
   values = ["x86_64"]
 }

 filter {
   name   = "virtualization-type"
   values = ["hvm"]
 }
}

data "aws_subnet" "slacko-app-subnet-public" {
   cidr_block = "10.0.102.0/24"
}

resource "aws_key_pair" "slacko-key-ssh" {
 key_name = "slacko-ssh-key"
 public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC7fXT+vXy6lrR6a46qDphn6W/Hx8coNtHYwz4Y0tJLjFkTzrd7s2EUH2ANg+nlwDCpZNd92ZcZyT94la8J5AIw6bLyBoj5YaKGxRIylk52zVAKB9EuXWlz
}

resource "aws_instance" "slacko-app" {
  ami = data.aws_ami.slacko-amazon.id
  instance_type = "t2.micro"
  subnet_id = data.aws_subnet.slacko-app-subnet-public.id
  associate_public_ip_address = true
  key_name = aws_key_pair.slacko-key-ssh.key_name
  user_data = file("ec2.sh")
  tags = {
      Name = "slacko-app"
    }  
}

resource "aws_instance" "slacko-mongodb" {
  ami = data.aws_ami.slacko-amazon.id
  instance_type = "t2.small"
  subnet_id = data.aws_subnet.slacko-app-subnet-public.id
  associate_public_ip_address = true
  key_name = aws_key_pair.slacko-key-ssh.key_name
  user_data = file("mongodb.sh")  
  tags = {
      Name = "slacko-mongodb"
    }  
}

resource "aws_security_group" "allow-http-ssh" {
name = "allow_http_ssh"
description = "Security group allows SSH and HTTP"
vpc_id = "vpc-0c07086c5f321dfd6"

 ingress = [
    {
      description = "Allowe SSH"
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = null
    },
  {

      description = "Allowe HTTP"
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = null
    }
 ]

egress = [

 {
   description = "Allowe HTTP"
   from_port = 0
   to_port = 0
   protocol = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
   ipv6_cidr_blocks = []
   prefix_list_ids = []
   security_groups = []
   self = null

 }      
 ]

 tags = {
      Name = "allow_ssh_http"
  }
}

resource "aws_network_interface_sg_attachment" "slacko-sg" {
  security_group_id = aws_security_group.allow-http-ssh.id
  network_interface_id = aws_instance.slacko-app.primary_network_interface_id
}

output "slacko-app-IP" {
  value = aws_instance.slacko-app.public_ip
}

output "slacko-mongodb-ip" {
 value = aws_instance.slacko-mongodb.private_ip
}
