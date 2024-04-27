#! /bin/bash
yum update -y
hostnamectl set-hostname docker-server
amazon-linux-extras install docker -y
systemctl start docker
systemctl enable docker
usermod -a -G docker ec2-user
