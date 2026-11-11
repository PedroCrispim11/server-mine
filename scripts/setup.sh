cat << 'EOF' > scripts/setup.sh
#!/bin/bash

# Atualiza o sistema
sudo apt update && sudo apt upgrade -y

# Instala o Java 17 (Recomendado para Minecraft 1.20+) e wget
sudo apt install openjdk-17-jre-headless wget -y

# Cria a pasta do servidor
mkdir -p ~/minecraft
cd ~/minecraft

# Baixa o instalador do Fabric (Exemplo para Minecraft 1.20.1)
wget https://maven.fabricmc.net/net/fabricmc/fabric-installer/0.11.2/fabric-installer-0.11.2.jar -O fabric-installer.jar

# Instala o servidor Fabric automaticamente (versão do MC: 1.20.1)
java -jar fabric-installer.jar server -mcversion 1.20.1 -downloadMinecraft

# Gera o EULA automaticamente
echo "eula=true" > eula.txt

echo "Setup do Fabric concluído com sucesso!"
EOF

chmod +x scripts/setup.sh