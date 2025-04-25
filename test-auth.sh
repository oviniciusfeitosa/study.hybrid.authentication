#!/bin/bash

# Script para testar a autenticação híbrida na POC

echo "Iniciando testes de autenticação híbrida..."
echo "============================================"

# Definir URLs
F5_URL="http://localhost:8090"
BACKEND_URL="http://localhost:8080"
AUTH_ENDPOINT="/api/auth/token"
USER_ENDPOINT="/api/user"
ADMIN_ENDPOINT="/api/admin"

# Cores para saída
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Função para testar autenticação
test_auth() {
  local username=$1
  local password=$2
  local description=$3
  local expected_status=$4

  echo -e "\n${YELLOW}Teste: $description${NC}"
  echo "Usuário: $username"
  
  # Fazer requisição de autenticação
  response=$(curl -s -X POST -H "Content-Type: application/json" \
    -d "{\"username\":\"$username\",\"password\":\"$password\"}" \
    $BACKEND_URL$AUTH_ENDPOINT)
  
  # Extrair token (se existir)
  token=$(echo $response | grep -o '"token":"[^"]*' | cut -d'"' -f4)
  
  if [ -z "$token" ]; then
    if [ "$expected_status" == "fail" ]; then
      echo -e "${GREEN}✓ Teste passou: Autenticação falhou conforme esperado${NC}"
    else
      echo -e "${RED}✗ Teste falhou: Não foi possível obter token${NC}"
      echo "Resposta: $response"
    fi
    return
  fi
  
  if [ "$expected_status" == "fail" ]; then
    echo -e "${RED}✗ Teste falhou: Autenticação bem-sucedida quando deveria falhar${NC}"
    return
  fi
  
  echo -e "${GREEN}✓ Autenticação bem-sucedida${NC}"
  
  # Testar acesso à API de usuário
  user_response=$(curl -s -H "Authorization: Bearer $token" $BACKEND_URL$USER_ENDPOINT)
  echo "Resposta da API de usuário: $user_response"
  
  # Testar acesso à API de admin (se for admin)
  if [ "$expected_status" == "admin" ]; then
    admin_response=$(curl -s -H "Authorization: Bearer $token" $BACKEND_URL$ADMIN_ENDPOINT)
    if [[ $admin_response == *"Acesso administrativo concedido"* ]]; then
      echo -e "${GREEN}✓ Acesso administrativo concedido${NC}"
    else
      echo -e "${RED}✗ Acesso administrativo negado${NC}"
      echo "Resposta: $admin_response"
    fi
  fi
}

# Testar autenticação via F5
test_f5_auth() {
  local username=$1
  local password=$2
  local description=$3
  local expected_status=$4

  echo -e "\n${YELLOW}Teste F5: $description${NC}"
  echo "Usuário: $username"
  
  # Fazer requisição de autenticação através do F5
  response=$(curl -s -X POST -H "Content-Type: application/json" \
    -d "{\"username\":\"$username\",\"password\":\"$password\"}" \
    $F5_URL$AUTH_ENDPOINT)
  
  # Extrair token (se existir)
  token=$(echo $response | grep -o '"token":"[^"]*' | cut -d'"' -f4)
  
  if [ -z "$token" ]; then
    if [ "$expected_status" == "fail" ]; then
      echo -e "${GREEN}✓ Teste F5 passou: Autenticação falhou conforme esperado${NC}"
    else
      echo -e "${RED}✗ Teste F5 falhou: Não foi possível obter token${NC}"
      echo "Resposta: $response"
    fi
    return
  fi
  
  if [ "$expected_status" == "fail" ]; then
    echo -e "${RED}✗ Teste F5 falhou: Autenticação bem-sucedida quando deveria falhar${NC}"
    return
  fi
  
  echo -e "${GREEN}✓ Autenticação F5 bem-sucedida${NC}"
  
  # Testar acesso à API de usuário através do F5
  user_response=$(curl -s -H "Authorization: Bearer $token" $F5_URL$USER_ENDPOINT)
  echo "Resposta da API de usuário via F5: $user_response"
}

echo -e "\n${YELLOW}Iniciando testes de autenticação direta no backend...${NC}"

# Testar usuário do AD
test_auth "user1" "password" "Autenticação de usuário do AD" "success"

# Testar admin do AD
test_auth "admin1" "password" "Autenticação de admin do AD" "admin"

# Testar usuário do Oracle
test_auth "usuario_oracle" "password123" "Autenticação de usuário do Oracle" "success"

# Testar admin do Oracle
test_auth "admin_oracle" "password123" "Autenticação de admin do Oracle" "admin"

# Testar usuário inexistente
test_auth "usuario_inexistente" "senha_qualquer" "Autenticação de usuário inexistente" "fail"

echo -e "\n${YELLOW}Iniciando testes de autenticação via F5...${NC}"

# Testar usuário do AD via F5
test_f5_auth "user1" "password" "Autenticação de usuário do AD via F5" "success"

# Testar usuário do Oracle via F5
test_f5_auth "usuario_oracle" "password123" "Autenticação de usuário do Oracle via F5" "success"

# Testar usuário inexistente via F5
test_f5_auth "usuario_inexistente" "senha_qualquer" "Autenticação de usuário inexistente via F5" "fail"

echo -e "\n${GREEN}Testes de autenticação híbrida concluídos!${NC}"
