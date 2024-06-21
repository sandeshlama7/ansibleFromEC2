#!/bin/bash
add-apt-repository --yes --update ppa:ansible/ansible
apt-get update -y
apt-get install -y ansible
ssh-keygen -t rsa -b 2048 -f /home/ubuntu/.ssh/id_rsa -N ""
cat /home/ubuntu/.ssh/id_rsa.pub >> /home/ubuntu/.ssh/authorized_keys
chmod 600 /home/ubuntu/.ssh/authorized_keys
chown ubuntu:ubuntu /home/ubuntu/.ssh/id_rsa
chown ubuntu:ubuntu /home/ubuntu/.ssh/id_rsa.pub
