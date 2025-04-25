#!/bin/bash

# Script para verificar a disponibilidade do banco de dados Oracle
# Este script será usado no healthcheck do container

sqlplus -L app_user/app_password@//localhost:1521/XEPDB1 <<EOF
SELECT 1 FROM DUAL;
EXIT;
EOF

if [ $? -eq 0 ]; then
    echo "Banco de dados Oracle está disponível"
    exit 0
else
    echo "Banco de dados Oracle não está disponível"
    exit 1
fi
