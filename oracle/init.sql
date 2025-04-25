-- Script de inicialização do banco de dados Oracle para POC de Autenticação Híbrida

-- Criação da tabela de usuários
CREATE TABLE usuarios (
    id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    username VARCHAR2(50) NOT NULL UNIQUE,
    password VARCHAR2(100) NOT NULL,
    nome VARCHAR2(100) NOT NULL,
    email VARCHAR2(100) NOT NULL,
    ativo NUMBER(1) DEFAULT 1 NOT NULL,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Inserção de usuários de teste
INSERT INTO usuarios (username, password, nome, email, ativo) 
VALUES ('usuario_oracle', '$2a$10$8.UnVuG9HHgffUDAlk8qfOuVGkqRzgVymGe07xd00DMxs.AQubh4a', 'Usuário Oracle', 'usuario.oracle@exemplo.com', 1);

INSERT INTO usuarios (username, password, nome, email, ativo) 
VALUES ('admin_oracle', '$2a$10$8.UnVuG9HHgffUDAlk8qfOuVGkqRzgVymGe07xd00DMxs.AQubh4a', 'Administrador Oracle', 'admin.oracle@exemplo.com', 1);

-- Criação da tabela de perfis
CREATE TABLE perfis (
    id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome VARCHAR2(50) NOT NULL UNIQUE
);

-- Inserção de perfis
INSERT INTO perfis (nome) VALUES ('ROLE_USER');
INSERT INTO perfis (nome) VALUES ('ROLE_ADMIN');

-- Criação da tabela de associação entre usuários e perfis
CREATE TABLE usuario_perfis (
    usuario_id NUMBER NOT NULL,
    perfil_id NUMBER NOT NULL,
    PRIMARY KEY (usuario_id, perfil_id),
    CONSTRAINT fk_usuario FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    CONSTRAINT fk_perfil FOREIGN KEY (perfil_id) REFERENCES perfis(id)
);

-- Associação de perfis aos usuários
INSERT INTO usuario_perfis (usuario_id, perfil_id) 
VALUES (1, 1);

INSERT INTO usuario_perfis (usuario_id, perfil_id) 
VALUES (2, 1);

INSERT INTO usuario_perfis (usuario_id, perfil_id) 
VALUES (2, 2);

-- Comentário: A senha em hash corresponde a 'password123' usando BCrypt
