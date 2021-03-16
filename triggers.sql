DELIMITER $$

CREATE TRIGGER deleta_empresa
    BEFORE DELETE
    ON empresas FOR EACH ROW
BEGIN
    INSERT INTO registros (registro, data_cadastro) VALUES
    (CONCAT('id: ', OLD.id_empresa, ' nome: ', OLD.nome, ' email: ', OLD.email), NOW());
END

$$    

DELIMITER ;;

CREATE TRIGGER deleta_fornecedor
    BEFORE DELETE
    ON fornecedores FOR EACH ROW
BEGIN
    INSERT INTO registros (registro, data_cadastro, empresa) VALUES
    (CONCAT('id: ', OLD.id_fornecedor, ' nome: ', OLD.fornecedor, ' email: ', OLD.email, ' fone: ', OLD.fone), NOW(), OLD.empresa);
END

;;

DELIMITER $$

CREATE TRIGGER deleta_produto
    BEFORE DELETE
    ON produtos FOR EACH ROW
BEGIN
    INSERT INTO registros (registro, data_cadastro, empresa) VALUES
    (CONCAT('id: ', OLD.id_produto, ' nome: ', OLD.produto, ' marca: ', OLD.marca, ' tipo: ', OLD.tipo, ' preco: ', OLD.preco_unitario), NOW(), OLD.empresa);
END

$$

DELIMITER ;;

CREATE TRIGGER deleta_estoque
    BEFORE DELETE
    ON estoques FOR EACH ROW
BEGIN
    INSERT INTO registros (registro, data_cadastro, empresa) VALUES
    (CONCAT('id: ', OLD.id_estoque, ' quantidade: ', OLD.quantidade, ' peso: ', OLD.peso_unitario, ' unidade_medida: ', OLD.unidade_medida, ' fornecedor: ', OLD.fornecedor, ' produto: ', OLD.produto), NOW(), OLD.empresa);
END

;;

DELIMITER $$

CREATE TRIGGER deleta_cardapio
    BEFORE DELETE
    ON cardapios FOR EACH ROW
BEGIN
    INSERT INTO registros (registro, data_cadastro, empresa) VALUES
    (CONCAT('id: ', OLD.id_cardapio, ' nome: ', OLD.nome, ' descricao: ', OLD.descricao), NOW(), OLD.empresa);
END

$$

DELIMITER ;;

CREATE TRIGGER deleta_item
    BEFORE DELETE
    ON itens FOR EACH ROW
BEGIN
    INSERT INTO registros (registro, data_cadastro, empresa) VALUES
    (CONCAT('id: ', OLD.id_item, ' nome: ', OLD.nome, ' descricao: ', OLD.descricao, ' preco: ', OLD.preco), NOW(), OLD.empresa);
END

;;

DELIMITER $$

CREATE TRIGGER deleta_cliente
    BEFORE DELETE
    ON clientes FOR EACH ROW
BEGIN
    INSERT INTO registros (registro, data_cadastro, empresa) VALUES
    (CONCAT('id: ', OLD.id_cliente, ' nome: ', OLD.nome, ' fone: ', OLD.fone, ' email: ', OLD.email), NOW(), OLD.empresa);
END

$$

DELIMITER $$

CREATE TRIGGER deleta_endereco
    BEFORE DELETE
    ON enderecos FOR EACH ROW
BEGIN
    INSERT INTO registros (registro, data_cadastro, empresa) VALUES
    (CONCAT('id: ', OLD.id_endereco, ' rua: ', OLD.rua, ' numero: ', OLD.numero, ' bairro: ', OLD.bairro, ' cidade: ', OLD.cidade, ' CEP: ', OLD.cep), NOW(), OLD.empresa);
END

$$

DELIMITER $$

CREATE TRIGGER deleta_frete
    BEFORE DELETE
    ON fretes FOR EACH ROW
BEGIN
    INSERT INTO registros (registro, data_cadastro, empresa) VALUES
    (CONCAT('id: ', OLD.id_frete, ' bairro: ', OLD.bairro, ' cidade: ', OLD.cidade, ' preco: ', OLD.preco), NOW(), OLD.empresa);
END

$$

DELIMITER $$

CREATE TRIGGER deleta_venda
    BEFORE DELETE
    ON vendas FOR EACH ROW
BEGIN
    INSERT INTO registros (registro, data_cadastro, empresa) VALUES
    (CONCAT('id: ', OLD.id_venda, ' endereco: ', OLD.endereco, ' frete: ', OLD.frete, ' progresso: ', OLD.progresso, ' preco_total: ', OLD.preco_total, ' cliente: ', OLD.cliente), NOW(), OLD.empresa);
END

$$

/* CONTROLE ESTOQUE */

DELIMITER $$

CREATE TRIGGER controle_estoques
    AFTER INSERT
    ON controle_estoques FOR EACH ROW
BEGIN
    UPDATE estoques SET quantidade = quantidade - new.saida + new.entrada WHERE id_estoque = new.estoque;
END

$$


DELIMITER $$

CREATE TRIGGER total_venda_acre
    AFTER INSERT
    ON itens_venda FOR EACH ROW
BEGIN
    UPDATE vendas SET preco_total = preco_total + new.preco WHERE id_venda = new.venda;
END

$$


DELIMITER $$

CREATE TRIGGER total_venda_decre
    AFTER DELETE
    ON itens_venda FOR EACH ROW
BEGIN
    UPDATE vendas SET preco_total = preco_total - OLD.preco WHERE id_venda = OLD.venda;
END

$$
