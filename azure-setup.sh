#!/bin/bash

set -e

RESOURCE_GROUP="rg-petflow"
LOCATION="chilecentral"
VM_NAME="petflow-vm"
USERNAME="azureuser"

echo "Criando Resource Group..."
az group create \
  --name "$RESOURCE_GROUP" \
  --location "$LOCATION"

echo "Criando VM (pode demorar alguns minutos)..."
az vm create \
  --resource-group "$RESOURCE_GROUP" \
  --name "$VM_NAME" \
  --image "Canonical:ubuntu-24_04-lts:server:latest" \
  --admin-username "$USERNAME" \
  --generate-ssh-keys \
  --size "Standard_B2als_v2"

echo "Abrindo porta 8080..."
az vm open-port \
  --resource-group "$RESOURCE_GROUP" \
  --name "$VM_NAME" \
  --port 8080

echo "Instalando Docker, Java 21, Maven e ferramentas..."

SETUP_CMD="
sudo apt-get update;
sudo apt-get install -y docker.io docker-compose-v2 git nano openjdk-21-jdk maven;
sudo systemctl enable docker;
sudo systemctl start docker;
sudo usermod -aG docker $USERNAME
"

az vm run-command invoke \
  --resource-group "$RESOURCE_GROUP" \
  --name "$VM_NAME" \
  --command-id RunShellScript \
  --scripts "$SETUP_CMD"

echo "Infraestrutura criada com sucesso!"
