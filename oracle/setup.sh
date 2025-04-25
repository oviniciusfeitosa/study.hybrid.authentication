#!/bin/bash

# Script para inicializar o banco de dados Oracle e executar scripts adicionais

echo "Iniciando configuração do banco de dados Oracle..."

# Aguardar o banco de dados estar pronto
echo "Aguardando o banco de dados estar disponível..."
until sqlplus -L app_user/app_password@//localhost:1521/XEPDB1 <<EOF
SELECT 1 FROM DUAL;
EXIT;
EOF
do
  echo "Aguardando o banco de dados inicializar..."
  sleep 5
done

echo "Banco de dados disponível. Executando scripts de configuração..."

# Executar script de configuração adicional
sqlplus app_user/app_password@//localhost:1521/XEPDB1 @/opt/oracle/scripts/config.sql

echo "Configuração do banco de dados Oracle concluída com sucesso!"
