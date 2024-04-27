#! /bin/bash
# Update all packages
sudo yum update -y

# Install Java (OpenJDK 11)
sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo

# Add the Jenkins repository
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key


# Import the Jenkins repository GPG key
sudo yum upgrade
# Install Jenkins
sudo yum install java-17-amazon-corretto -y
sudo yum install jenkins -y

# Enable and start the Jenkins service
sudo systemctl enable jenkins
sudo systemctl start jenkins

amazon-linux-extras install docker -y
systemctl start docker
systemctl enable docker
usermod -a -G docker ec2-user
usermod -a -G docker jenkins
cp /lib/systemd/system/docker.service /lib/systemd/system/docker.service.bak
sed -i 's/^ExecStart=.*/ExecStart=\/usr\/bin\/dockerd -H tcp:\/\/127.0.0.1:2375 -H unix:\/\/\/var\/run\/docker.sock/g' /lib/systemd/system/docker.service
systemctl daemon-reload
systemctl restart docker
systemctl restart jenkins
# uninstall aws cli version 1
rm -rf /bin/aws
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install
amazon-linux-extras install ansible2 -y
