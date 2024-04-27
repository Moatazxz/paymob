#! /bin/bash
yum update -y
hostnamectl set-hostname ansible-server
amazon-linux-extras install ansible2 -y
