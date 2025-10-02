resource "aws_instance" "devops_php" {
  ami                    = "ami-08982f1c5bf93d976" #Amazon Linux 3 AMI
  instance_type          = "t3.micro"
  key_name               = "bia"
  vpc_security_group_ids = [aws_security_group.devops-test.id]
  iam_instance_profile   = aws_iam_instance_profile.ecr-ec2-role.name

  user_data = <<-EOF
              #!/bin/bash

              # Log de início
              exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
              echo "Starting user-data script at $(date)"

              # Instalar Docker, Git, jq e AWS CLI
              echo "Installing basic packages..."
              sudo yum update -y
              sudo yum install git -y
              sudo yum install docker -y
              sudo yum install jq -y

              # Instalar AWS CLI v2
              echo "Installing AWS CLI v2..."
              curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
              sudo yum install unzip -y
              unzip awscliv2.zip
              sudo ./aws/install
              rm -rf awscliv2.zip aws/

              # Configurar usuários no grupo docker
              echo "Configuring docker users..."
              sudo usermod -a -G docker ec2-user
              sudo usermod -a -G docker ssm-user
              id ec2-user ssm-user

              # Ativar docker
              echo "Enabling and starting Docker..."
              sudo systemctl enable docker.service
              sudo systemctl start docker.service

              # Instalar docker compose 2
              echo "Installing Docker Compose v2..."
              sudo mkdir -p /usr/local/lib/docker/cli-plugins
              sudo curl -SL https://github.com/docker/compose/releases/download/v2.23.3/docker-compose-linux-x86_64 -o /usr/local/lib/docker/cli-plugins/docker-compose
              sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

              # Adicionar swap
              echo "Configuring swap..."
              sudo dd if=/dev/zero of=/swapfile bs=128M count=32
              sudo chmod 600 /swapfile
              sudo mkswap /swapfile
              sudo swapon /swapfile
              echo "/swapfile swap swap defaults 0 0" | sudo tee -a /etc/fstab

              # Instalar node e npm
              echo "Installing Node.js and npm..."
              curl -fsSL https://rpm.nodesource.com/setup_21.x | sudo bash -
              sudo yum install -y nodejs

              # Configurar python 3.11 e uv para uso com mcp servers da aws
              echo "Installing Python 3.11 and uv..."
              sudo dnf install python3.11 -y
              sudo ln -sf /usr/bin/python3.11 /usr/bin/python3

              sudo -u ec2-user bash -c 'curl -LsSf https://astral.sh/uv/install.sh | sh'
              echo 'export PATH="$HOME/.local/bin:$PATH"' >> /home/ec2-user/.bashrc

              # Verificar instalações
              echo "Verifying installations..."
              docker --version
              docker compose version
              aws --version
              node --version
              npm --version
              python3 --version

              # Log de conclusão
              echo "User data script completed successfully at $(date)"
              echo "SUCCESS" > /var/log/userdata-completion.log
              EOF

  tags = {
    Name        = "devops-teste"
    Provisioned = "Terraform"
    Cliente     = "DOT"
  }
}

