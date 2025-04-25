-- Arquivo de configuração adicional para Oracle Database
-- Este arquivo contém configurações adicionais para otimização do banco de dados

-- Configuração de parâmetros de performance
ALTER SYSTEM SET processes=300 SCOPE=SPFILE;
ALTER SYSTEM SET sessions=335 SCOPE=SPFILE;
ALTER SYSTEM SET sga_target=1G SCOPE=SPFILE;
ALTER SYSTEM SET pga_aggregate_target=500M SCOPE=SPFILE;

-- Configuração de parâmetros de segurança
ALTER SYSTEM SET audit_trail=DB SCOPE=SPFILE;
ALTER SYSTEM SET sec_case_sensitive_logon=TRUE SCOPE=SPFILE;

-- Criação de índices para melhorar a performance das consultas
CREATE INDEX idx_usuarios_username ON usuarios(username);
CREATE INDEX idx_perfis_nome ON perfis(nome);

-- Criação de view para facilitar consultas de usuários com seus perfis
CREATE OR REPLACE VIEW vw_usuarios_perfis AS
SELECT u.id, u.username, u.nome, u.email, u.ativo, p.nome as perfil
FROM usuarios u
JOIN usuario_perfis up ON u.id = up.usuario_id
JOIN perfis p ON up.perfil_id = p.id;

-- Comentário: Este script será executado após a criação das tabelas principais
