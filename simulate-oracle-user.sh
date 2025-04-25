#!/bin/bash

# Script para simular um usuário do banco Oracle para testes

echo "Simulando usuário do banco Oracle para testes..."
echo "================================================"

# Cores para saída
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Dados do usuário simulado
USERNAME="usuario_oracle"
PASSWORD="password123"
NOME="Usuário Oracle"
EMAIL="usuario.oracle@exemplo.com"

echo -e "${YELLOW}Dados do usuário do Oracle:${NC}"
echo "Username: $USERNAME"
echo "Password: $PASSWORD"
echo "Nome: $NOME"
echo "Email: $EMAIL"

# Simular consulta ao banco de dados
echo -e "\n${YELLOW}Simulando consulta ao banco de dados Oracle...${NC}"
echo "SELECT * FROM usuarios WHERE username = '$USERNAME'"
echo -e "${GREEN}Usuário encontrado no banco de dados${NC}"

# Simular verificação de senha
echo -e "\n${YELLOW}Verificando senha com BCrypt...${NC}"
echo -e "${GREEN}Senha verificada com sucesso${NC}"

# Simular obtenção de perfis
echo -e "\n${YELLOW}Obtendo perfis do usuário...${NC}"
echo "Perfil: ROLE_USER"

echo -e "\n${GREEN}Simulação de usuário do Oracle concluída com sucesso!${NC}"
