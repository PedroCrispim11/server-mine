terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# 1. Obter a AMI mais recente do Ubuntu 22.04 LTS oficialmente
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

# 2. Criar o Security Group (Portas 22 e 25565)
resource "aws_security_group" "minecraft_sg" {
  name        = "minecraft-sg"
  description = "Permite acesso SSH e Minecraft"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Minecraft Server"
    from_port   = 25565
    to_port     = 25565
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 3. Criar a Instância EC2 (Ajustável via variável instance_type)
resource "aws_instance" "minecraft_server" {
  ami                  = data.aws_ami.ubuntu.id
  instance_type        = var.instance_type
  key_name             = var.key_name
  security_groups      = [aws_security_group.minecraft_sg.name]

  root_block_device {
    volume_size = 30 # 30 GB de armazenamento
    volume_type = "gp3"
  }

  tags = {
    Name = "Minecraft-Cobblemon-Server"
  }
}

# 4. Criar o IP Elástico (IP Fixo) e associar à instância
resource "aws_eip" "minecraft_eip" {
  instance = aws_instance.minecraft_server.id
  domain   = "vpc"
}

# Output para você ver o IP gerado no terminal
output "minecraft_public_ip" {
  value       = aws_eip.minecraft_eip.public_ip
  description = "IP Publico fixo para conectar no Minecraft"
}