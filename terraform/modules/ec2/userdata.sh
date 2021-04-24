#!/usr/bin/bash
sudo yum update -y
sudo yum install git -y
git clone https://github.com/Roystonpp/python-web-app.git
cd python-web-app
systemctl enable docker
systemctl start docker
docker build --tag python-docker-app .
sleep 15s
aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin 674528447826.dkr.ecr.eu-west-1.amazonaws.com
docker tag python-docker-app:latest 674528447826.dkr.ecr.eu-west-1.amazonaws.com/python-app-ecr:v1
docker push 674528447826.dkr.ecr.eu-west-1.amazonaws.com/python-app-ecr:v1