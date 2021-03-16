DELIMITER $$

CREATE PROCEDURE cadastrar_frete(
    IN v_bairro VARCHAR(200),
    IN v_cidade VARCHAR(200),
    IN v_preco DECIMAL(10,2),
    IN v_id INT
  )
BEGIN
  IF ((v_bairro != '') && (v_preco != '') && (v_id != '')) THEN
    IF verifica_existencia_empresa(v_id) THEN
      INSERT INTO fretes (bairro, cidade, preco, empresa, data_cadastro) 
      VALUES (v_bairro, v_cidade, v_preco, v_id, NOW());

      SELECT * FROM fretes WHERE id_frete = LAST_INSERT_ID();
    ELSE
      SELECT 'Empresa não existe!' AS 'E';
    END IF;
  ELSE
    SELECT 'Valores não podem ser nulos!' AS 'E';
  END IF;
END

$$

DELIMITER $$

CREATE PROCEDURE atualizar_frete(
    IN v_id_frete INT,
    IN v_bairro VARCHAR(200),
    IN v_cidade VARCHAR(200),
    IN v_preco DECIMAL(10,2),
    IN v_id INT
  )
BEGIN
  IF ((v_bairro != '') && (v_preco != '') && (v_id != '') && (v_id_frete != '')) THEN
    IF verifica_existencia_empresa(v_id) THEN
      IF verifica_existencia_frete(v_id_frete, v_id) THEN
        UPDATE fretes 
        SET 
          bairro = v_bairro,
          cidade = v_cidade,
          preco = v_preco,
          data_atualizado = NOW()
        WHERE empresa = v_id AND id_frete = v_id_frete;
      ELSE
        SELECT 'Frete não existe!' AS 'E';
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

CREATE PROCEDURE deletar_frete(
    IN v_id_frete INT,
    IN v_id INT
  )
BEGIN
  IF ((v_id != '') && (v_id_frete != '')) THEN
    IF verifica_existencia_empresa(v_id) THEN
      IF verifica_existencia_frete(v_id_frete, v_id) THEN
        DELETE FROM fretes WHERE empresa = v_id AND id_frete = v_id_frete;
      ELSE
        SELECT 'Frete não existe!' AS 'E';
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

CREATE PROCEDURE pesquisa_fretes(
    IN v_q VARCHAR(200),
    IN v_off INT,
    IN v_row INT,
    IN v_id INT
  )
BEGIN

  SELECT COUNT(*) AS total, v_off offset, v_row linha FROM lista_fretes WHERE empresa = v_id AND MATCH(bairro, cidade) AGAINST(v_q IN BOOLEAN MODE);
  SELECT * FROM lista_fretes WHERE empresa = v_id AND MATCH(bairro, cidade) AGAINST(v_q IN BOOLEAN MODE) LIMIT v_off, v_row;

END

$$


DELIMITER $$

CREATE PROCEDURE lista_fretes(
    IN v_off INT,
    IN v_row INT,
    IN v_id INT
  )
BEGIN

  SELECT COUNT(*) AS total, v_off offset, v_row linha FROM lista_fretes WHERE empresa = v_id;
  SELECT * FROM lista_fretes WHERE empresa = v_id LIMIT v_off, v_row;

END

$$