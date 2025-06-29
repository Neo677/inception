#!/bin/bash
set -e

echo "Suppression des anciennes installations Docker..."
sudo apt remove -y docker docker-engine docker.io containerd runc || true
sudo apt purge -y docker-ce docker-ce-cli containerd.io docker-compose-plugin || true
sudo rm -rf /var/lib/docker /var/lib/containerd
sudo rm -f /etc/apt/sources.list.d/docker.list
sudo rm -rf /etc/apt/keyrings/docker.gpg

echo "Installation des dependances..."
sudo apt update
sudo apt install -y ca-certificates curl gnupg lsb-release

echo "Ajout de la cle GPG Docker officielle..."
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | \
  sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "Ajout du depot Docker officiel..."
echo \
  "deb [arch=arm64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "Installation de Docker..."
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

echo "Activation du service Docker..."
sudo systemctl unmask docker
sudo systemctl enable docker
sudo systemctl start docker

echo "Docker est maintenant installe et actif !"
docker --version
docker compose version
