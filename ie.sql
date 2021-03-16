CREATE DATABASE IF NOT EXISTS ie;
USE ie;

CREATE TABLE IF NOT EXISTS empresas (
    id_empresa INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    email VARCHAR(100) NOT NULL,
    senha VARCHAR(50) NOT NULL,
    data_cadastro DATETIME, 
    data_atualizado DATETIME, 
    fone VARCHAR(50),

    FULLTEXT (nome, email)
);

CREATE TABLE IF NOT EXISTS registros (
    id_registro INT AUTO_INCREMENT PRIMARY KEY,
    registro VARCHAR(400),
    data_cadastro DATETIME,
    empresa INT,

    CONSTRAINT empresa_registro
        FOREIGN KEY (empresa) REFERENCES empresas(id_empresa)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    FULLTEXT KEY (registro)
);

CREATE TABLE IF NOT EXISTS fornecedores (
    id_fornecedor INT AUTO_INCREMENT PRIMARY KEY,
    fornecedor VARCHAR(50) NOT NULL,
    fone VARCHAR(50),
    email VARCHAR(100),
    data_cadastro DATETIME, 
    data_atualizado DATETIME, 
    empresa INT NOT NULL,

    CONSTRAINT empresa_fornecedores
        FOREIGN KEY (empresa) REFERENCES empresas(id_empresa)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    FULLTEXT (fornecedor, email, fone)
);

CREATE TABLE IF NOT EXISTS produtos (
    id_produto INT AUTO_INCREMENT PRIMARY KEY,
    produto VARCHAR(100) NOT NULL,
    marca VARCHAR(100),
    tipo ENUM ('pronto', 'ingrediente') NOT NULL, 
    preco_unitario DECIMAL(10,2) NOT NULL, 
    descricao VARCHAR(100),
    data_cadastro DATETIME, 
    data_atualizado DATETIME, 
    empresa INT NOT NULL,

    CONSTRAINT empresa_produtos
        FOREIGN KEY (empresa) REFERENCES empresas(id_empresa)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    FULLTEXT (produto, marca, descricao)
);

CREATE TABLE IF NOT EXISTS estoques (
    id_estoque INT AUTO_INCREMENT PRIMARY KEY,
    quantidade INT NOT NULL,
    peso_unitario DECIMAL(10,5),
    unidade_medida VARCHAR(10),
    data_cadastro DATETIME, 
    data_atualizado DATETIME, 
    fornecedor INT,
    empresa INT NOT NULL,
    produto INT NOT NULL,

    CONSTRAINT empresa_estoques
        FOREIGN KEY (empresa) REFERENCES empresas(id_empresa)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fornecedor_estoque
        FOREIGN KEY (fornecedor) REFERENCES fornecedores(id_fornecedor)
        ON DELETE SET NULL
        ON UPDATE CASCADE,

    CONSTRAINT produto_estoque
        FOREIGN KEY (produto) REFERENCES produtos(id_produto)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS controle_estoques (
    id_registro INT AUTO_INCREMENT PRIMARY KEY,
    data_registro DATE,
    entrada INT,
    saida INT,
    empresa INT NOT NULL,
    estoque INT NOT NULL,

    CONSTRAINT empresa_estoques_registro
        FOREIGN KEY (empresa) REFERENCES empresas(id_empresa)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT registro_estoque
        FOREIGN KEY (estoque) REFERENCES estoques(id_estoque)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS cardapios (
    id_cardapio INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao VARCHAR(200),
    data_cadastro DATETIME, 
    data_atualizado DATETIME, 
    empresa INT NOT NULL,

    CONSTRAINT empresa_cardapios
        FOREIGN KEY (empresa) REFERENCES empresas(id_empresa)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    FULLTEXT (nome, descricao)
);

CREATE TABLE IF NOT EXISTS itens (
    id_item INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao VARCHAR(200),
    marca VARCHAR(50),
    tipo ENUM ('pronto', 'processado') NOT NULL, 
    preco DECIMAL(10,2) NOT NULL,
    data_cadastro DATETIME, 
    data_atualizado DATETIME, 
    empresa INT NOT NULL,

    CONSTRAINT empresa_itens
        FOREIGN KEY (empresa) REFERENCES empresas(id_empresa)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    FULLTEXT (nome, descricao)
);

CREATE TABLE IF NOT EXISTS itens_cardapios (
    id_cardapio INT NOT NULL,
    id_item INT NOT NULL,
    data_cadastro DATETIME,

    CONSTRAINT cardapio_itens_cardapio
        FOREIGN KEY (id_cardapio) REFERENCES cardapios(id_cardapio)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT item_itens_cardapio
        FOREIGN KEY (id_item) REFERENCES itens(id_item)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS produtos_ingredientes (
    id_produto INT NOT NULL,
    ingrediente INT NOT NULL,
    peso_quantidade DECIMAL(15,5),
    unidade_medida VARCHAR(5),
    data_cadastro DATETIME, 
    data_atualizado DATETIME, 

    CONSTRAINT produto_ingre
        FOREIGN KEY (id_produto) REFERENCES produtos(id_produto)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT ingrediente_prod
        FOREIGN KEY (ingrediente) REFERENCES produtos(id_produto)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS produtos_itens (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_produto INT NOT NULL,
    id_item INT NOT NULL,
    peso_quantidade DECIMAL(15,5),
    unidade_medida VARCHAR(5),
    data_cadastro DATETIME, 
    data_atualizado DATETIME, 

    CONSTRAINT produto_item
        FOREIGN KEY (id_produto) REFERENCES produtos(id_produto)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT item_itens
        FOREIGN KEY (id_item) REFERENCES itens(id_item)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    fone VARCHAR(50) NOT NULL,
    email VARCHAR(100),
    data_cadastro DATETIME, 
    data_atualizado DATETIME, 
    empresa INT NOT NULL,

    CONSTRAINT empresa_clientes
        FOREIGN KEY (empresa) REFERENCES empresas(id_empresa)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    FULLTEXT (nome, fone, email)
);

CREATE TABLE IF NOT EXISTS enderecos (
    id_endereco INT AUTO_INCREMENT PRIMARY KEY,
    rua VARCHAR(100),
    numero INT,
    bairro VARCHAR(100),
    cidade VARCHAR(100),
    cep VARCHAR(100),
    data_cadastro DATETIME, 
    data_atualizado DATETIME, 
    empresa INT,

    CONSTRAINT empresa_ender
        FOREIGN KEY (empresa) REFERENCES empresas(id_empresa)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    FULLTEXT (rua, bairro, cidade, cep)
);

CREATE TABLE IF NOT EXISTS enderecos_clientes (
    endereco INT NOT NULL,
    cliente INT NOT NULL,

    CONSTRAINT cliente_end_cliente
        FOREIGN KEY (cliente) REFERENCES clientes(id_cliente)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT end_end_cliente
        FOREIGN KEY (endereco) REFERENCES enderecos(id_endereco)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS fretes (
    id_frete INT AUTO_INCREMENT PRIMARY KEY,
    bairro VARCHAR(200) NOT NULL,
    cidade VARCHAR(200),
    preco DECIMAL(10,2) NOT NULL,
    data_cadastro DATETIME, 
    data_atualizado DATETIME, 
    empresa INT,

    CONSTRAINT empresa_fretes
        FOREIGN KEY (empresa) REFERENCES empresas(id_empresa)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    FULLTEXT (bairro, cidade)
);

CREATE TABLE IF NOT EXISTS vendas (
    id_venda INT AUTO_INCREMENT PRIMARY KEY,
    endereco INT,
    frete DECIMAL(5,2),
    progresso ENUM ('cancelado', 'producao', 'despachado', 'entregue') NOT NULL,
    preco_total DECIMAL(10,2),
    desconto DECIMAL(5,2),
    cliente INT,
    data_criado DATETIME,
    data_atualizado DATETIME,
    empresa INT NOT NULL,

    CONSTRAINT empresa_vendas
        FOREIGN KEY (empresa) REFERENCES empresas(id_empresa)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT cliente_venda
        FOREIGN KEY (cliente) REFERENCES clientes(id_cliente)
        ON DELETE SET NULL
        ON UPDATE CASCADE,

    CONSTRAINT endereco_venda
        FOREIGN KEY (endereco) REFERENCES enderecos(id_endereco)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS itens_venda (
    id INT AUTO_INCREMENT PRIMARY KEY,
    venda INT NOT NULL,
    item INT NOT NULL,
    nome VARCHAR(100) NOT NULL,
    preco DECIMAL(10,2) NOT NULL,

    CONSTRAINT item_venda_venda
        FOREIGN KEY (venda) REFERENCES vendas(id_venda)
        ON DELETE CASCADE
        ON UPDATE CASCADE,    

    CONSTRAINT item_venda_item
        FOREIGN KEY (item) REFERENCES itens(id_item)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS enderecos_empresas (
    endereco INT NOT NULL,
    empresa INT NOT NULL,

    CONSTRAINT empresa_end_empresas
        FOREIGN KEY (empresa) REFERENCES empresas(id_empresa)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT end_end_empresas
        FOREIGN KEY (endereco) REFERENCES enderecos(id_endereco)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS enderecos_fornecedores (
    endereco INT NOT NULL,
    fornecedor INT NOT NULL,

    CONSTRAINT fornecedor_end
        FOREIGN KEY (fornecedor) REFERENCES fornecedores(id_fornecedor)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT end_fornecedor
        FOREIGN KEY (endereco) REFERENCES enderecos(id_endereco)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS privilegio_empresas (
    privilegio ENUM ('bloqueado', 'normal', 'alto') NOT NULL,
    empresa INT NOT NULL,
    data_atualizado DATETIME, 

    CONSTRAINT empresa_privilegio
        FOREIGN KEY (empresa) REFERENCES empresas(id_empresa)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS custos_fixos (
    id_custo INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nome VARCHAR(200),
    valor DECIMAL(10,2),
    dia_vencimento INT,
    data_atualizado DATETIME,
    data_cadastro DATETIME, 
    empresa INT NOT NULL,

    CONSTRAINT empresa_custo
        FOREIGN KEY (empresa) REFERENCES empresas(id_empresa)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS funcionarios (
    id_funcionario INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nome VARCHAR(200),
    funcao VARCHAR(200),
    salario DECIMAL(10,2),
    dia_pagamento INT,
    data_atualizado DATETIME,
    data_cadastro DATETIME, 
    empresa INT NOT NULL,

    CONSTRAINT empresa_func
        FOREIGN KEY (empresa) REFERENCES empresas(id_empresa)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
