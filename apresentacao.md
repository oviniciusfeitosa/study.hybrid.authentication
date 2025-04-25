# Apresentação da POC de Autenticação Híbrida

## Objetivo

Demonstrar uma solução de autenticação híbrida que verifica usuários no Active Directory via LDAP e, caso não encontre, busca na tabela de usuários do banco Oracle.

## Componentes da Solução

1. **Backend Spring Boot**
   - Implementação da lógica de autenticação híbrida
   - Integração com LDAP e Oracle
   - OAuth2 com JWT

2. **Frontend Angular**
   - Interface de usuário para login
   - Gerenciamento de tokens JWT
   - Rotas protegidas

3. **Banco de Dados Oracle**
   - Armazenamento de usuários e perfis
   - Tabelas otimizadas para consulta

4. **Servidor LDAP**
   - Simulação de Active Directory
   - Estrutura de usuários e grupos

5. **Simulador F5**
   - Proxy com OAuth2 client_credentials
   - Gerenciamento de tokens

## Fluxo de Autenticação

1. Usuário envia credenciais
2. Sistema verifica no Active Directory
3. Se não encontrado, verifica no Oracle
4. Se autenticado, gera token JWT
5. Cliente usa token para acessar recursos protegidos

## Demonstração

- Autenticação de usuário do AD
- Autenticação de usuário do Oracle
- Falha de autenticação para usuário inexistente
- Acesso a recursos protegidos
- Verificação de permissões

## Benefícios

- Flexibilidade na gestão de usuários
- Integração com sistemas legados
- Segurança com tokens JWT
- Arquitetura moderna e escalável
- Facilidade de manutenção

## Próximos Passos

- Implementação em ambiente de produção
- Integração com Active Directory real
- Implementação de refresh tokens
- Auditoria de acessos
- Configuração de F5 real

## Conclusão

A POC demonstra com sucesso a implementação de uma autenticação híbrida que atende aos requisitos especificados, utilizando tecnologias modernas e seguindo boas práticas de desenvolvimento.
