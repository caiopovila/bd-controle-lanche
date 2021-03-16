DELIMITER $$

CREATE PROCEDURE cadastrar_item(
    IN v_nome VARCHAR(100),
    IN v_descricao VARCHAR(200),
    IN v_preco DECIMAL(10,2),
    IN v_marca VARCHAR(50),
    IN v_tipo INT,
    IN v_id INT
  )
BEGIN
  IF ((v_id != '') && (v_nome != '') && (v_preco != '') && (v_tipo != '')) THEN
    IF verifica_existencia_empresa(v_id) THEN
        IF (v_marca != '') THEN
            INSERT INTO itens (nome, descricao, marca, tipo, preco, empresa, data_cadastro) 
            VALUES (v_nome, v_descricao, v_marca, v_tipo, v_preco, v_id, NOW());
        ELSE
            INSERT INTO itens (nome, descricao, tipo, preco, empresa, data_cadastro) 
            VALUES (v_nome, v_descricao, v_tipo, v_preco, v_id, NOW());
        END IF;
      SELECT * FROM itens WHERE id_item = LAST_INSERT_ID();
    ELSE
      SELECT 'Empresa não existe!' AS 'E';
    END IF;
  ELSE
    SELECT 'Valores não podem ser nulos!' AS 'E';
  END IF;
END

$$

DELIMITER $$

CREATE PROCEDURE atualizar_item(
    IN v_id_tem INT,
    IN v_nome VARCHAR(100),
    IN v_descricao VARCHAR(200),
    IN v_marca VARCHAR(50),
    IN v_preco DECIMAL(10,2),
    IN v_id INT
  )
BEGIN
  IF ((v_id != '') && (v_nome != '') && (v_preco != '') && (v_id_tem != '')) THEN
    IF verifica_existencia_empresa(v_id) THEN
      IF verifica_existencia_item(v_id_tem, v_id) THEN
        IF (v_marca != '') THEN
            UPDATE itens 
            SET 
            nome = v_nome,
            descricao = v_descricao,
            marca = v_marca,
            preco = v_preco,
            data_atualizado = NOW()
            WHERE id_item = v_id_tem AND empresa = v_id;
        ELSE
            UPDATE itens 
            SET 
            nome = v_nome,
            descricao = v_descricao,
            preco = v_preco,
            data_atualizado = NOW()
            WHERE id_item = v_id_tem AND empresa = v_id;
        END IF;
      ELSE
        SELECT 'Item não existe!' AS 'E';  
      END IF;
    ELSE
      SELECT 'Empresa não existe!' AS 'E';
    END IF;
  ELSE
    SELECT 'Valores não podem ser nulos!' AS 'E';
  END IF;
END

$$

DELIMITER $$

CREATE PROCEDURE add_produto_item(
    IN v_id_produto INT,
    IN v_id_item INT,
    IN v_peso_quantidade DECIMAL(15,5),
    IN v_medida VARCHAR(5),
    IN v_id INT
  )
BEGIN
  IF ((v_id_produto != '') && (v_id_item != '')) THEN
    IF verifica_existencia_produto(v_id_produto, v_id) THEN
      IF verifica_existencia_item(v_id_item, v_id) THEN
        IF verifica_item_processado(v_id_item, v_id) THEN
            IF verifica_produto_ingrediente(v_id_produto, v_id) THEN
                INSERT INTO produtos_itens (id_produto, id_item, peso_quantidade, unidade_medida, data_cadastro) 
                VALUES (v_id_produto, v_id_item, v_peso_quantidade, v_medida, NOW());
            ELSE
                SELECT 'Produto não é ingrediente!' AS 'E';  
            END IF;
        ELSE
            SELECT 'Item não processado!' AS 'E';  
        END IF;
      ELSE
        SELECT 'Item não existe!' AS 'E';  
      END IF;
    ELSE
      SELECT 'Produto não existe!' AS 'E';
    END IF;
  ELSE
    SELECT 'Valores não podem ser nulos!' AS 'E';
  END IF;
END

$$

DELIMITER $$

CREATE PROCEDURE remover_produto_item(
    IN v_id_produto INT,
    IN v_id_item INT,
    IN v_id INT
  )
BEGIN
  IF ((v_id_produto != '') && (v_id_item != '')) THEN
      IF verifica_existencia_item(v_id_item, v_id) THEN
        DELETE FROM produtos_itens WHERE id = v_id_produto AND id_item = v_id_item;
      ELSE
        SELECT 'Item não existe!' AS 'E';  
      END IF;
  ELSE
    SELECT 'Valores não podem ser nulos!' AS 'E';
  END IF;
END

$$

DELIMITER $$

CREATE PROCEDURE add_item_cardapio(
    IN v_id_tem INT,
    IN v_id_cardapio INT,
    IN v_id INT
  )
BEGIN
  IF ((v_id_cardapio != '') && (v_id_tem != '')) THEN
    IF verifica_existencia_cardapio(v_id_cardapio, v_id) THEN
      IF verifica_existencia_item(v_id_tem, v_id) THEN
        INSERT INTO itens_cardapios (id_cardapio, id_item, data_cadastro) VALUES (v_id_cardapio, v_id_tem, NOW());
      ELSE
        SELECT 'Item não existe!' AS 'E';  
      END IF;
    ELSE
      SELECT 'Cardapio não existe!' AS 'E';
    END IF;
  ELSE
    SELECT 'Valores não podem ser nulos!' AS 'E';
  END IF;
END

$$

DELIMITER $$

CREATE PROCEDURE remover_item_cardapio(
    IN v_id_tem INT,
    IN v_id_cardapio INT,
    IN v_id INT
  )
BEGIN
  IF ((v_id_cardapio != '') && (v_id_tem != '')) THEN
    IF verifica_existencia_cardapio(v_id_cardapio, v_id) THEN
      IF verifica_existencia_item(v_id_tem, v_id) THEN
        DELETE FROM itens_cardapios WHERE id_item = v_id_tem AND id_cardapio = v_id_cardapio;
      ELSE
        SELECT 'Item não existe!' AS 'E';  
      END IF;
    ELSE
      SELECT 'Cardapio não existe!' AS 'E';
    END IF;
  ELSE
    SELECT 'Valores não podem ser nulos!' AS 'E';
  END IF;
END

$$

DELIMITER $$

CREATE PROCEDURE deletar_item(
    IN v_id_tem INT,
    IN v_id INT
  )
BEGIN
  IF ((v_id != '') && (v_id_tem != '')) THEN
    IF verifica_existencia_empresa(v_id) THEN
      IF verifica_existencia_item(v_id_tem, v_id) THEN
        DELETE FROM itens WHERE id_item = v_id_tem AND empresa = v_id;
      ELSE
        SELECT 'Item não existe!' AS 'E';  
      END IF;
    ELSE
      SELECT 'Empresa não existe!' AS 'E';
    END IF;
  ELSE
    SELECT 'Valores não podem ser nulos!' AS 'E';
  END IF;
END

$$

/* search */
DELIMITER $$

CREATE PROCEDURE pesquisa_itens(
    IN v_q CHAR(200),
    IN v_off INT,
    IN v_row INT,
    IN v_id INT
  )
BEGIN

  SELECT COUNT(*) AS total, v_off offset, v_row linha FROM lista_itens WHERE empresa = v_id AND MATCH(nome, descricao) AGAINST(v_q IN BOOLEAN MODE); 
  SELECT * FROM lista_itens WHERE empresa = v_id AND MATCH(nome, descricao) AGAINST(v_q IN BOOLEAN MODE) LIMIT v_off, v_row;

END

$$

DELIMITER $$

CREATE PROCEDURE lista_itens(
    IN v_off INT,
    IN v_row INT,
    IN v_id INT
  )
BEGIN

  SELECT COUNT(*) AS total, v_off offset, v_row linha FROM lista_itens WHERE empresa = v_id;
  SELECT * FROM lista_itens WHERE empresa = v_id LIMIT v_off, v_row;

END

$$

DELIMITER $$

CREATE PROCEDURE lista_itens_fora_cardapio(
    IN v_id_cardapio INT,
    IN v_id INT
  )
BEGIN

  SELECT * FROM lista_itens WHERE empresa = v_id AND NOT EXISTS (select * from lista_itens_cardapio where  id_cardapio in (v_id_cardapio) and lista_itens.id_item = lista_itens_cardapio.id_item);

END

$$

DELIMITER $$

CREATE PROCEDURE pegar_item(
    IN v_id_item INT,
    IN v_id INT
  )
BEGIN
    SELECT * FROM itens_detalhes WHERE id_item = v_id_item AND empresa = v_id;
END

$$