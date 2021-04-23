#!/usr/bin/bash
sudo apt-get update
sudo apt install git -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
git clone https://github.com/Roystonpp/python-web-app.git
echo \
  "deb [arch=arm64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get install docker-ce docker-ce-cli containerd.io -y

cd python-web-app
docker build --tag python-docker-app .

sudo docker run python-docker-app -d
