#!/bin/bash
sudo hostnamectl set-hostname ${new_hostname} &&
sudo apt-get install -y apt-transport-https software-properties-common wget &&
wget -q -o - https://packages.grafana.com/gpg.key | sudo apt-key add - &&
echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee -a /ect/apt/sources.list.d/grafana.list &&
sudo apt-get update &&
sudo apt-get install grafana &&
sudo systemctl start grafana &&
sudo systemctl enable grafana-server.service