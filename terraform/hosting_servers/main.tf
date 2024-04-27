terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
# Network

#Create a vpc
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

#Create internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

#public subnet
resource "aws_subnet" "public-us-east-1a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}

#Route table 
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public_route_table"
  }
}

#Route table association
resource "aws_route_table_association" "public-us-east-1a" {
  subnet_id      = aws_subnet.public-us-east-1a.id
  route_table_id = aws_route_table.public_route_table.id
}
#####################################


#IAM Roles 
resource "aws_iam_role" "aws_access" {
  name = "awsrole-jenkins"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess", "arn:aws:iam::aws:policy/AmazonEC2FullAccess", "arn:aws:iam::aws:policy/IAMFullAccess" , "arn:aws:iam::aws:policy/AmazonS3FullAccess"]

}

resource "aws_iam_instance_profile" "ec2-profile" {
  name = "jenkins-server"
  role = aws_iam_role.aws_access.name
}

######################################

# create SSH key pair
resource "aws_key_pair" "TF_key" {
  key_name   = "TF_key"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "TF-key" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "tfkey.pem"
}
###############################

#EC2
#hosting servers 

#jenkins server 
resource "aws_instance" "jenkins-server" {
  ami = "ami-026b57f3c383c2eec"
  instance_type = "m5.large"
  subnet_id    = aws_subnet.public-us-east-1a.id
  key_name      = "TF_key"
  vpc_security_group_ids = [aws_security_group.jenkins-sec-gr.id]
  iam_instance_profile = aws_iam_instance_profile.ec2-profile.name
ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 20  # Specify the new volume size in GiB
    volume_type = "gp2"  # You can also specify a different volume type if needed
    delete_on_termination = true  # Whether to delete the volume when the instance is terminated
  }

  user_data = file("jenkins.sh")
    tags = {
    Name = "jenkins"
  }

}

#docker sever 
resource "aws_instance" "docker-server" {
  ami = "ami-026b57f3c383c2eec"
  instance_type = "t2.medium"
  subnet_id    = aws_subnet.public-us-east-1a.id
  key_name      = "TF_key"
  vpc_security_group_ids = [aws_security_group.jenkins-sec-gr.id]
  iam_instance_profile = aws_iam_instance_profile.ec2-profile.name
  user_data = file("docker.sh")
    tags = {
    Name = "docker"
  }

}
  
  #Ansible sever
  resource "aws_instance" "ansible-server" { 
  ami = "ami-026b57f3c383c2eec"
  instance_type = "t2.medium"
  subnet_id    = aws_subnet.public-us-east-1a.id
  key_name      = "TF_key"
  vpc_security_group_ids = [aws_security_group.jenkins-sec-gr.id]
  iam_instance_profile = aws_iam_instance_profile.ec2-profile.name
  user_data = file("Ansible.sh")
    tags = {
    Name = "Ansible"
  }

}


#Security groups 

#Jenkins SG
resource "aws_security_group" "jenkins-sec-gr" {
  name = "jenkins-sg"
  vpc_id = aws_vpc.main.id  

  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    protocol    = "tcp"
    to_port     = 8080
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = -1
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "jenkins-sg"
  }
}

#dDocker-sg
resource "aws_security_group" "docker_sg" {
  name        = "docker-sg"
  vpc_id = aws_vpc.main.id 

  # Allow SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # General outbound access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Docker SG"
  }
}

#Ansible sg 
resource "aws_security_group" "ansible_sg" {
  name        = "ansible-sg"

  vpc_id   = aws_vpc.main.id

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
    Name = "Ansible SG"
  }
}


output "jenkins-server" {
  value = "http://${aws_instance.jenkins-server.public_ip}:8080"
}

output "docker-server" {
  value = "http://${aws_instance.docker-server.public_ip}"
}



