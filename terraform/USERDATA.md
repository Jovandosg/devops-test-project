# User Data Script - EC2 Instance Bootstrap

## 📋 Descrição

Este script é executado automaticamente quando a instância EC2 é iniciada pela primeira vez. Ele configura todos os requisitos necessários para executar a aplicação PHP containerizada.

## 🔧 Componentes Instalados

### 1. **Ferramentas Básicas**
- **Git**: Controle de versão
- **Docker**: Containerização
- **jq**: Processamento de JSON
- **unzip**: Descompactação de arquivos

### 2. **AWS CLI v2**
- Versão mais recente do AWS CLI
- Necessário para interagir com serviços AWS (ECR, S3, etc.)

### 3. **Docker & Docker Compose**
- **Docker Engine**: Para executar containers
- **Docker Compose v2.23.3**: Para orquestração de múltiplos containers
- Usuários `ec2-user` e `ssm-user` adicionados ao grupo docker

### 4. **Swap Memory**
- **4GB de swap** (128M x 32 blocos)
- Melhora a performance em instâncias t3.micro
- Configurado para persistir após reboot

### 5. **Node.js & npm**
- **Node.js v21**: Runtime JavaScript
- **npm**: Gerenciador de pacotes Node

### 6. **Python 3.11 & uv**
- **Python 3.11**: Versão específica para compatibilidade
- **uv**: Gerenciador de pacotes Python ultrarrápido
- Configurado para uso com MCP servers da AWS

## 📊 Logs

### Verificar execução do user_data:
```bash
# Log completo
sudo cat /var/log/user-data.log

# Status de conclusão
cat /var/log/userdata-completion.log

# Logs do sistema
sudo journalctl -u cloud-init-output
```

### Verificar instalações:
```bash
docker --version
docker compose version
aws --version
node --version
npm --version
python3 --version
```

## 🔄 Aplicar Mudanças

Para aplicar o user_data em uma nova instância:

```bash
cd terraform
terraform plan
terraform apply
```

**⚠️ IMPORTANTE**: O user_data só é executado na **primeira inicialização** da instância. Para aplicar mudanças:

1. **Opção 1**: Destruir e recriar a instância
   ```bash
   terraform destroy -target=aws_instance.devops_php
   terraform apply
   ```

2. **Opção 2**: Executar manualmente via SSH
   ```bash
   ssh -i sua-chave.pem ec2-user@<IP-DA-INSTANCIA>
   # Execute os comandos manualmente
   ```

3. **Opção 3**: Usar `user_data_replace_on_change = true` (Terraform 1.5+)
   ```hcl
   resource "aws_instance" "devops_php" {
     # ... outras configurações
     user_data_replace_on_change = true
   }
   ```

## 🎯 Tempo de Execução

O script completo leva aproximadamente **5-10 minutos** para ser executado completamente, dependendo da velocidade da rede e da instância.

## ✅ Verificação de Sucesso

Após a instância estar em execução, verifique:

```bash
# Conectar via SSH
ssh -i bia.pem ec2-user@<IP-DA-INSTANCIA>

# Verificar se o script foi concluído
cat /var/log/userdata-completion.log
# Deve mostrar: SUCCESS

# Testar Docker
docker ps

# Testar Docker Compose
docker compose version

# Testar AWS CLI
aws sts get-caller-identity
```

## 🐛 Troubleshooting

### Script não executou:
```bash
# Verificar logs do cloud-init
sudo cat /var/log/cloud-init-output.log
sudo cat /var/log/cloud-init.log
```

### Docker não está funcionando:
```bash
# Verificar status do Docker
sudo systemctl status docker

# Reiniciar Docker
sudo systemctl restart docker

# Verificar permissões
groups ec2-user
```

### AWS CLI não funciona:
```bash
# Verificar instalação
which aws
aws --version

# Testar credenciais (via IAM Role)
aws sts get-caller-identity
```
