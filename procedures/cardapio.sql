
DELIMITER $$

CREATE PROCEDURE cadastrar_cardapio(
    IN v_nome VARCHAR(100),
    IN v_descricao VARCHAR(200),
    IN v_id INT
  )
BEGIN
  IF ((v_id != '') && (v_nome != '')) THEN
    IF verifica_existencia_empresa(v_id) THEN
      INSERT INTO cardapios (nome, descricao, empresa, data_cadastro) 
      VALUES (v_nome, v_descricao, v_id, NOW());

      SELECT * FROM cardapios WHERE id_cardapio = LAST_INSERT_ID();
    ELSE
      SELECT 'Empresa não existe!' AS 'E';
    END IF;
  ELSE
    SELECT 'Valores não podem ser nulos!' AS 'E';
  END IF;
END

$$

DELIMITER $$

CREATE PROCEDURE atualizar_cardapio(
    IN v_id_cardapio INT,
    IN v_nome VARCHAR(100),
    IN v_descricao VARCHAR(200),
    IN v_id INT
  )
BEGIN
  IF ((v_id != '') && (v_nome != '') && (v_id_cardapio != '')) THEN
    IF verifica_existencia_empresa(v_id) THEN
      IF verifica_existencia_cardapio(v_id_cardapio, v_id) THEN
        UPDATE cardapios 
        SET 
          nome = v_nome, 
          descricao = v_descricao,
          data_atualizado = NOW()
        WHERE empresa = v_id AND id_cardapio = v_id_cardapio;
      ELSE
        SELECT 'Cardapio não existe!' AS 'E';
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

CREATE PROCEDURE deletar_cardapio(
    IN v_id_cardapio INT,
    IN v_id INT
  )
BEGIN
  IF ((v_id != '') && (v_id_cardapio != '')) THEN
    IF verifica_existencia_empresa(v_id) THEN
      IF verifica_existencia_cardapio(v_id_cardapio, v_id) THEN
        DELETE FROM cardapios WHERE empresa = v_id AND id_cardapio = v_id_cardapio;
      ELSE
        SELECT 'Cardapio não existe!' AS 'E';
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

CREATE PROCEDURE pegar_cardapio(
    IN v_id_cardapio INT,
    IN v_id INT
  )
BEGIN
    SELECT * FROM lista_cardapios WHERE id_cardapio = v_id_cardapio AND empresa = v_id;
    SELECT * FROM lista_itens_cardapio WHERE empresa = v_id AND id_cardapio = v_id_cardapio;
END

$$

DELIMITER $$

CREATE PROCEDURE lista_cardapio(
    IN v_id_cardapio INT,
    IN v_id INT
  )
BEGIN
    SELECT * FROM lista_cardapios WHERE empresa = v_id;
END

$$

DELIMITER $$

CREATE PROCEDURE lista_item_cardapio(
    IN v_id_cardapio INT,
    IN v_id INT
  )
BEGIN
    SELECT * FROM lista_itens_cardapio WHERE empresa = v_id AND id_cardapio = v_id_cardapio;
END

$$