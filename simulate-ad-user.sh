#!/bin/bash

# Script para simular um usuário do Active Directory para testes

echo "Simulando usuário do Active Directory para testes..."
echo "==================================================="

# Cores para saída
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Dados do usuário simulado
USERNAME="user1"
PASSWORD="password"
DISPLAY_NAME="Usuario LDAP"
EMAIL="user1@example.org"

echo -e "${YELLOW}Dados do usuário do AD:${NC}"
echo "Username: $USERNAME"
echo "Password: $PASSWORD"
echo "Nome: $DISPLAY_NAME"
echo "Email: $EMAIL"

# Simular autenticação LDAP
echo -e "\n${YELLOW}Simulando autenticação LDAP...${NC}"
echo -e "${GREEN}Usuário autenticado com sucesso via LDAP${NC}"

# Simular obtenção de grupos
echo -e "\n${YELLOW}Obtendo grupos do usuário...${NC}"
echo "Grupo: users"

# Simular verificação de permissões
echo -e "\n${YELLOW}Verificando permissões...${NC}"
echo -e "${GREEN}Usuário possui permissão: ROLE_USER${NC}"

echo -e "\n${GREEN}Simulação de usuário do AD concluída com sucesso!${NC}"
