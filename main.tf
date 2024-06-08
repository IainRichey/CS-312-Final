terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

resource "aws_security_group" "minecraft_sg" {
  name        = "minecraft_sg"
  description = "Allow Minecraft access"

  ingress {
    from_port   = 25565
    to_port     = 25565
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
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

resource "aws_instance" "minecraft_server" {
  ami                         = "ami-04b70fa74e45c3917"
  instance_type               = "t2.medium"
  key_name                    = "my-minecraft-key2"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.minecraft_sg.id]

  connection {
    type        = "ssh"
    user        = "ubuntu" # Assuming Ubuntu AMI, adjust if necessary
    private_key = file("~/.ssh/my-minecraft-key2.pem")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y docker.io",
      "sudo systemctl enable docker",
      "sudo docker pull itzg/minecraft-server",
      "echo '[Unit]' | sudo tee /etc/systemd/system/minecraft.service",
      "echo 'Description=Minecraft Server' | sudo tee -a /etc/systemd/system/minecraft.service",
      "echo 'After=network.target' | sudo tee -a /etc/systemd/system/minecraft.service",
      "echo '' | sudo tee -a /etc/systemd/system/minecraft.service",
      "echo '[Service]' | sudo tee -a /etc/systemd/system/minecraft.service",
      "echo 'Restart=always' | sudo tee -a /etc/systemd/system/minecraft.service",
      "echo 'ExecStart=/usr/bin/docker run -d -p 25565:25565 -e EULA=TRUE itzg/minecraft-server' | sudo tee -a /etc/systemd/system/minecraft.service",
      "echo 'ExecStop=/usr/bin/docker stop %n' | sudo tee -a /etc/systemd/system/minecraft.service",
      "echo '' | sudo tee -a /etc/systemd/system/minecraft.service",
      "echo '[Install]' | sudo tee -a /etc/systemd/system/minecraft.service",
      "echo 'WantedBy=multi-user.target' | sudo tee -a /etc/systemd/system/minecraft.service",
      "sudo systemctl enable minecraft.service",
      "sudo systemctl start minecraft.service"
    ]
  }

  tags = {
    Name = "MinecraftServer"
  }
}
