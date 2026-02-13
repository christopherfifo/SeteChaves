CREATE DATABASE setechaves;

USE setechaves;

CREATE TABLE usuarios (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100),
    email VARCHAR(100) UNIQUE NOT NULL,
    senha VARCHAR(255) NOT NULL
);

INSERT INTO usuarios (nome, email, senha) VALUES ('Admin', 'admin@teste.com', '123');

CREATE TABLE senhas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    usuario_id INT NOT NULL,
    nome_servico VARCHAR(100) NOT NULL,
    login_servico VARCHAR(100) NOT NULL,
    senha_servico VARCHAR(255) NOT NULL,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

ALTER TABLE senhas ADD COLUMN descricao VARCHAR(255);

ALTER TABLE senhas ADD COLUMN data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

UPDATE usuarios 
SET senha = 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3' 
WHERE email = 'admin@teste.com';

ALTER TABLE usuarios ADD COLUMN codigo_recuperacao VARCHAR(10);

ALTER TABLE usuarios ADD COLUMN validade_codigo TIMESTAMP NULL;

select * from usuarios;