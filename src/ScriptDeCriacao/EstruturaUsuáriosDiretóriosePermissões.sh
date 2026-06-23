echo " Iniciando provisionamento de usuários e diretórios..."

# ================================
# 1. Criação de Grupos
# ================================
groups=("dev" "qa" "infra")

for group in "${groups[@]}"; do
  if ! getent group "$group" > /dev/null; then
    groupadd "$group"
    echo " Grupo criado: $group"
  else
    echo " Grupo já existe: $group"
  fi
done

# ================================
# 2. Criação de Usuários
# ================================
declare -A users
users=(
  ["alice"]="dev"
  ["bob"]="qa"
  ["carol"]="infra"
)

for user in "${!users[@]}"; do
  if ! id "$user" &>/dev/null; then
    useradd -m -s /bin/bash -G "${users[$user]}" "$user"
    echo "$user:123456" | chpasswd
    passwd -e "$user"
    echo "Usuário criado: $user (grupo: ${users[$user]})"
  else
    echo "Usuário já existe: $user"
  fi
done

# ================================
# 3. Criação de Diretórios
# ================================
mkdir -p /empresa/{dev,qa,infra}

echo "Diretórios criados em /empresa"

# ================================
# 4. Donos e Grupos
# ================================
chown root:dev /empresa/dev
chown root:qa /empresa/qa
chown root:infra /empresa/infra

# ================================
# 5. Permissões
# ================================
chmod 770 /empresa/dev
chmod 770 /empresa/qa
chmod 770 /empresa/infra

# ================================
# 6. Permissões Especiais (SGID)
# ================================
chmod g+s /empresa/dev
chmod g+s /empresa/qa
chmod g+s /empresa/infra
# Como executar.
chmod +x provision_users_dirs.sh
sudo ./provision_users_dirs.sh
