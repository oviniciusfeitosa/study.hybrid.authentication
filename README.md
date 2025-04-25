# Guia de Instalação e Execução da POC de Autenticação Híbrida

Este guia fornece instruções detalhadas para instalar e executar a Prova de Conceito (POC) de autenticação híbrida que integra Active Directory via LDAP e banco de dados Oracle.

## Pré-requisitos

- Sistema operacional Ubuntu 24.04 ou compatível
- Docker e Docker Compose instalados
- Java 17 ou superior
- Node.js 18 ou superior
- Maven 3.6 ou superior
- Acesso à internet para download de dependências

## Estrutura de Diretórios

```
poc-autenticacao-hibrida/
├── backend/               # Backend Spring Boot
├── frontend/              # Frontend Angular
├── oracle/                # Configurações do banco Oracle
├── ldap/                  # Configurações do servidor LDAP
├── f5-config/             # Simulador F5 com OAuth2
├── docker-compose.yml     # Configuração dos serviços
├── start-poc.sh           # Script de inicialização
├── test-auth.sh           # Script de testes
├── documentacao.md        # Documentação completa
└── README.md              # Instruções básicas
```

## Passos para Instalação

1. **Clone o repositório**

   ```bash
   git clone https://github.com/sua-organizacao/poc-autenticacao-hibrida.git
   cd poc-autenticacao-hibrida
   ```

2. **Verifique as permissões dos scripts**

   ```bash
   chmod +x start-poc.sh test-auth.sh simulate-ad-user.sh simulate-oracle-user.sh
   ```

3. **Inicie os serviços**

   ```bash
   ./start-poc.sh
   ```

   Este script irá:
   - Construir todas as imagens Docker necessárias
   - Iniciar todos os containers
   - Verificar se os serviços estão funcionando corretamente
   - Executar os testes de autenticação

4. **Aguarde a inicialização completa**

   A inicialização pode levar alguns minutos, especialmente para o banco de dados Oracle. O script mostrará o progresso e informará quando todos os serviços estiverem prontos.

## Acessando os Serviços

Após a inicialização bem-sucedida, você pode acessar os seguintes serviços:

- **Frontend Angular**: http://localhost:4200
- **Backend Spring Boot**: http://localhost:8080
- **Simulador F5**: http://localhost:8090
- **phpLDAPadmin**: http://localhost:8081

## Credenciais para Teste

### Usuários do Active Directory

- **Usuário comum**:
  - Username: user1
  - Password: password

- **Administrador**:
  - Username: admin1
  - Password: password

### Usuários do Banco Oracle

- **Usuário comum**:
  - Username: usuario_oracle
  - Password: password123

- **Administrador**:
  - Username: admin_oracle
  - Password: password123

## Executando Testes Manualmente

Para executar os testes de autenticação manualmente:

```bash
./test-auth.sh
```

Para simular usuários específicos:

```bash
./simulate-ad-user.sh    # Simula usuário do Active Directory
./simulate-oracle-user.sh # Simula usuário do banco Oracle
```

## Verificando Logs

Para verificar os logs dos serviços:

```bash
# Log do backend
docker-compose logs -f spring-backend

# Log do frontend
docker-compose logs -f angular-frontend

# Log do simulador F5
docker-compose logs -f f5-simulator

# Log do banco Oracle
docker-compose logs -f oracle-db

# Log do servidor LDAP
docker-compose logs -f ldap-server
```

## Parando os Serviços

Para parar todos os serviços:

```bash
docker-compose down
```

Para parar e remover volumes (isso apagará os dados do banco):

```bash
docker-compose down -v
```

## Solução de Problemas

### Problema: Serviços não iniciam corretamente

Verifique se as portas necessárias estão disponíveis:
- 4200: Frontend Angular
- 8080: Backend Spring Boot
- 8090: Simulador F5
- 1521: Oracle Database
- 389/636: LDAP
- 8081: phpLDAPadmin

### Problema: Erro de autenticação

Verifique se os serviços LDAP e Oracle estão funcionando corretamente:

```bash
docker-compose ps
```

### Problema: Erro ao construir imagens Docker

Verifique se você tem permissões suficientes e espaço em disco:

```bash
docker system df
```

## Próximos Passos

Para mais informações sobre a arquitetura, fluxo de autenticação e detalhes técnicos, consulte o arquivo `documentacao.md`.

## Suporte

Para questões ou problemas, entre em contato com a equipe de desenvolvimento.
