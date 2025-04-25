#!/bin/bash

# Script para iniciar todos os serviços da POC e executar os testes

echo "Iniciando serviços da POC de Autenticação Híbrida..."
echo "==================================================="

# Cores para saída
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Verificar se o Docker está rodando
if ! docker info > /dev/null 2>&1; then
  echo -e "${RED}Erro: Docker não está rodando. Por favor, inicie o serviço Docker.${NC}"
  exit 1
fi

# Parar containers existentes
echo -e "${YELLOW}Parando containers existentes...${NC}"
docker-compose down

# Construir e iniciar os serviços
echo -e "${YELLOW}Construindo e iniciando os serviços...${NC}"
docker-compose build
docker-compose up -d

# Aguardar serviços iniciarem
echo -e "${YELLOW}Aguardando serviços iniciarem...${NC}"
echo "Isso pode levar alguns minutos, especialmente para o Oracle Database."

# Verificar se os serviços estão rodando
check_service() {
  local service=$1
  local max_attempts=$2
  local attempt=1
  
  echo -n "Verificando $service "
  
  while [ $attempt -le $max_attempts ]; do
    if docker-compose ps | grep $service | grep -q "Up"; then
      echo -e "${GREEN}✓${NC}"
      return 0
    fi
    echo -n "."
    sleep 5
    attempt=$((attempt+1))
  done
  
  echo -e "${RED}✗${NC}"
  echo -e "${RED}Erro: $service não iniciou corretamente.${NC}"
  return 1
}

# Verificar cada serviço
check_service "oracle-db" 30 || exit 1
check_service "ldap-server" 10 || exit 1
check_service "spring-backend" 20 || exit 1
check_service "angular-frontend" 10 || exit 1
check_service "f5-simulator" 10 || exit 1

echo -e "${GREEN}Todos os serviços estão rodando!${NC}"

# Executar testes de autenticação
echo -e "${YELLOW}Executando testes de autenticação híbrida...${NC}"
./test-auth.sh

echo -e "\n${GREEN}POC de Autenticação Híbrida está pronta para uso!${NC}"
echo "Frontend Angular: http://localhost:4200"
echo "Backend Spring Boot: http://localhost:8080"
echo "Simulador F5: http://localhost:8090"
echo "phpLDAPadmin: http://localhost:8081"
