
DELIMITER $$

CREATE PROCEDURE cadastrar_produto(
    IN v_nome VARCHAR(100),
    IN v_marca VARCHAR(100),
    IN v_preco DECIMAL(10,2),
    IN v_tipo INT,
    IN v_id INT
  )
BEGIN
  IF ((v_id != '') && (v_nome != '') && (v_preco != '') && (v_tipo != '')) THEN
    IF verifica_existencia_empresa(v_id) THEN
      INSERT INTO produtos (produto, marca, tipo, preco_unitario, empresa, data_cadastro) 
      VALUES (v_nome, v_marca, v_tipo, v_preco, v_id, NOW());

      SELECT * FROM produtos WHERE id_produto = LAST_INSERT_ID();
    ELSE
      SELECT 'Empresa não existe!' AS 'E';
    END IF;
  ELSE
    SELECT 'Valores não podem ser nulos!' AS 'E';
  END IF;
END

$$

DELIMITER $$

CREATE PROCEDURE atualizar_produto(
    IN v_id_produto INT,
    IN v_nome VARCHAR(100),
    IN v_marca VARCHAR(100),
    IN v_preco DECIMAL(10,2),
    IN v_id INT
  )
BEGIN
  IF ((v_id != '') && (v_nome != '') && (v_preco != '') && (v_id_produto != '')) THEN
    IF verifica_existencia_empresa(v_id) THEN
      IF verifica_existencia_produto(v_id_produto, v_id) THEN
        UPDATE produtos 
        SET 
          produto = v_nome,
          marca = v_marca,
          preco_unitario = v_preco,
          data_atualizado = NOW()
        WHERE id_produto = v_id_produto AND empresa = v_id;
      ELSE
        SELECT 'Produto não existe!' AS 'E';
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

CREATE PROCEDURE deletar_produto(
    IN v_id_produto INT,
    IN v_id INT
  )
BEGIN
  IF ((v_id != '') && (v_id_produto != '')) THEN
    IF verifica_existencia_empresa(v_id) THEN
      IF verifica_existencia_produto(v_id_produto, v_id) THEN
        DELETE FROM produtos WHERE id_produto = v_id_produto AND empresa = v_id;
      ELSE
        SELECT 'Produto não existe!' AS 'E';
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

CREATE PROCEDURE pesquisa_produto(
    IN v_q VARCHAR(200),
    IN v_off INT,
    IN v_row INT,
    IN v_id INT
  )
BEGIN

  SELECT COUNT(*) AS total, v_off offset, v_row linha FROM detalhes_produtos WHERE empresa = v_id AND MATCH(produto, marca, descricao) AGAINST(v_q IN BOOLEAN MODE);
  SELECT * FROM detalhes_produtos WHERE empresa = v_id AND MATCH(produto, marca, descricao) AGAINST(v_q IN BOOLEAN MODE) LIMIT v_off, v_row;

END

$$

DELIMITER $$

CREATE PROCEDURE lista_produtos(
    IN v_off INT,
    IN v_row INT,
    IN v_id INT
  )
BEGIN

  SELECT COUNT(*) AS total, v_off offset, v_row linha FROM detalhes_produtos WHERE empresa = v_id;
  SELECT * FROM detalhes_produtos WHERE empresa = v_id LIMIT v_off, v_row;

END

$$

DELIMITER $$

CREATE PROCEDURE lista_item_produto(
    IN v_id_produto INT,
    IN v_id INT
  )
BEGIN

    SELECT * FROM lista_itens_produtos WHERE id_produto = v_id_produto AND empresa = v_id;

END

$$