#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

apt-get update -y
apt-get install -y \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg-agent \
  software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io

usermod -aG docker ubuntu

# Installing python
apt install -y python3
apt install -y python3-pip
pip3 install pipenv
pip3 install virtualenv

# Installing postgres
apt-get install -y postgresql postgresql-contrib postgresql-server-dev-all
apt install -y gcc

# Organizing mlflow environment
mkdir /home/ubuntu/mlflow  # Change directory as needed
cd /home/ubuntu/mlflow    # Change directory as needed
sudo pipenv install mlflow
sudo pipenv install psycopg2
sudo pipenv install awscli
sudo pipenv install boto3

# Run the required commands in the virtual environment
su - ubuntu -c "cd /home/ubuntu/mlflow && pipenv shell"
