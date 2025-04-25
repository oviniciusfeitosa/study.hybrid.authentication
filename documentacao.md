# Documentação da POC de Autenticação Híbrida

## Visão Geral

Esta Prova de Conceito (POC) demonstra uma solução de autenticação híbrida que verifica usuários em duas fontes diferentes:
1. Active Directory (AD) via LDAP
2. Banco de dados Oracle

A autenticação híbrida verifica primeiro se o usuário existe no Active Directory e, caso não encontre, busca na tabela de usuários do Oracle. Se o usuário não for encontrado em nenhuma das duas fontes, a autenticação falha e não é gerado token para acesso à aplicação.

## Arquitetura da Solução

A solução é composta pelos seguintes componentes:

### 1. Backend (Spring Boot)
- Implementa a lógica de autenticação híbrida
- Fornece endpoints REST para autenticação e acesso a recursos protegidos
- Integra-se com LDAP para consulta ao Active Directory
- Integra-se com banco de dados Oracle para consulta de usuários
- Implementa OAuth2 com JWT para geração de tokens de acesso

### 2. Frontend (Angular)
- Interface de usuário para login e acesso a recursos protegidos
- Implementa comunicação com o backend via HTTP
- Gerencia tokens JWT para autenticação
- Implementa rotas protegidas com guards de autenticação

### 3. Banco de Dados Oracle
- Armazena usuários e perfis para autenticação
- Fornece tabelas para consulta de usuários quando não encontrados no AD

### 4. Servidor LDAP
- Simula um Active Directory para autenticação de usuários
- Fornece estrutura de usuários e grupos para consulta

### 5. Simulador F5
- Atua como proxy entre o cliente e o backend
- Implementa autenticação OAuth2 com client_credentials
- Gerencia tokens de acesso para requisições ao backend

## Diagrama de Arquitetura

```
+----------------+     +----------------+     +----------------+
|                |     |                |     |                |
|    Cliente     +---->+  Simulador F5  +---->+    Backend     |
|   (Browser)    |     |   (Node.js)    |     |  (Spring Boot) |
|                |     |                |     |                |
+----------------+     +----------------+     +-------+--------+
                                                      |
                                                      |
                                              +-------v--------+
                                              |                |
                                              |  Autenticação  |
                                              |    Híbrida     |
                                              |                |
                                              +-------+--------+
                                                      |
                                                      |
                              +---------------------+-v-+---------------------+
                              |                     |                         |
                      +-------v--------+    +-------v--------+       +-------v--------+
                      |                |    |                |       |                |
                      |      LDAP      |    |     Oracle     |       |   Geração de   |
                      | (Active Dir.)  |    |  (Banco Dados) |       |     Tokens     |
                      |                |    |                |       |                |
                      +----------------+    +----------------+       +----------------+
```

## Fluxo de Autenticação Híbrida

1. **Requisição de Autenticação**:
   - O usuário envia credenciais (username/password) para o endpoint de autenticação
   - Se a requisição vier através do F5, este utiliza client_credentials para obter um token de sistema

2. **Verificação no Active Directory**:
   - O sistema tenta autenticar o usuário no Active Directory via LDAP
   - Se o usuário for encontrado e a senha estiver correta, a autenticação é bem-sucedida
   - As permissões do usuário são obtidas dos grupos do AD

3. **Verificação no Banco Oracle** (apenas se não encontrado no AD):
   - Se o usuário não for encontrado no AD, o sistema busca na tabela de usuários do Oracle
   - Se o usuário for encontrado e a senha estiver correta, a autenticação é bem-sucedida
   - As permissões do usuário são obtidas dos perfis associados no banco de dados

4. **Geração de Token**:
   - Após autenticação bem-sucedida, um token JWT é gerado
   - O token contém informações do usuário e suas permissões
   - O token é retornado ao cliente para uso em requisições subsequentes

5. **Acesso a Recursos Protegidos**:
   - O cliente inclui o token JWT no header de autorização das requisições
   - O backend valida o token e verifica as permissões do usuário
   - Se o token for válido e o usuário tiver permissão, o acesso é concedido

## Componentes Técnicos

### Backend (Spring Boot)

- **Autenticação Híbrida**: Implementada através do `HybridAuthenticationProvider`
- **Segurança**: Configurada com Spring Security e OAuth2
- **Tokens JWT**: Gerados e validados com biblioteca JJWT
- **Integração LDAP**: Implementada com Spring LDAP
- **Acesso ao Banco**: Implementado com Spring Data JPA

### Frontend (Angular)

- **Autenticação**: Implementada com serviço de autenticação e interceptor HTTP
- **Rotas Protegidas**: Implementadas com guards de autenticação
- **Componentes**: Login, Home, Admin e Navbar
- **Comunicação**: Implementada com HttpClient para requisições ao backend

### Banco de Dados Oracle

- **Tabelas**: Usuários, Perfis e associação entre eles
- **Índices**: Otimizados para consulta por username
- **Segurança**: Senhas armazenadas com hash BCrypt

### Simulador F5

- **Proxy**: Implementado com Express.js
- **OAuth2**: Implementado com client_credentials para obtenção de tokens
- **Encaminhamento**: Requisições encaminhadas para o backend com token

## Configuração e Execução

### Pré-requisitos

- Docker e Docker Compose
- Java 17
- Node.js
- Maven

### Inicialização

Para iniciar todos os serviços e executar os testes:

```bash
./start-poc.sh
```

Este script:
1. Constrói e inicia todos os containers Docker
2. Aguarda a inicialização de todos os serviços
3. Executa os testes de autenticação híbrida
4. Exibe as URLs para acesso aos serviços

### Testes Manuais

Para testar manualmente a autenticação:

1. **Usuário do AD**:
   - Username: user1
   - Password: password

2. **Administrador do AD**:
   - Username: admin1
   - Password: password

3. **Usuário do Oracle**:
   - Username: usuario_oracle
   - Password: password123

4. **Administrador do Oracle**:
   - Username: admin_oracle
   - Password: password123

## Considerações de Segurança

- Senhas armazenadas com hash BCrypt
- Comunicação protegida com tokens JWT
- Tokens com tempo de expiração limitado
- Verificação de permissões em cada requisição
- Validação de entrada em todos os endpoints

## Limitações da POC

- Ambiente simulado para Active Directory
- Configurações simplificadas para demonstração
- Sem implementação de renovação de tokens
- Sem implementação de logout no servidor

## Próximos Passos

Para uma implementação em produção, considerar:

1. Configuração de HTTPS para todas as comunicações
2. Implementação de renovação de tokens (refresh tokens)
3. Integração com Active Directory real
4. Implementação de auditoria de acessos
5. Implementação de rate limiting para prevenção de ataques
6. Configuração de F5 real com iRules para autenticação

## Conclusão

Esta POC demonstra com sucesso a implementação de uma autenticação híbrida que verifica usuários no Active Directory via LDAP e, caso não encontre, busca na tabela de usuários do Oracle. A solução utiliza tecnologias modernas como Spring Boot, Angular, Docker e OAuth2, e pode ser adaptada para ambientes de produção com as devidas considerações de segurança.
