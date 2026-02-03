# Atualiza o sistema.
sudo apt update -y
sudo apt upgrade -y

# Instala o Apache.
sudo apt install apache2 -y

# Habilita o Apache no boot.
sudo systemctl enable apache2

# Inicia o serviço.
sudo systemctl start apache2

# Libera a porta 80 (se UFW estiver ativo).
sudo ufw allow 80/tcp || true

# Como usar.
chmod +x provision_apache.sh
./provision_apache.sh
