
DELIMITER $$

CREATE PROCEDURE cadastrar_fornecedor(
  IN v_nome VARCHAR(100),
  IN v_fone VARCHAR(40),
  IN v_email VARCHAR(100),
  IN v_id INT
  )
BEGIN
  DECLARE id_generete INT DEFAULT 0;
  IF ((v_nome != '') && (v_id != '')) THEN
    IF verifica_existencia_empresa(v_id) THEN  
      START TRANSACTION;
        INSERT INTO fornecedores (fornecedor, fone, email, empresa, data_cadastro) VALUES (v_nome, v_fone, v_email, v_id, NOW());
        SET id_generete = LAST_INSERT_ID();
        SELECT * FROM lista_fornecedores WHERE id_fornecedor = id_generete;
      COMMIT;
    ELSE
      SELECT 'Empresa não existe!' AS 'E';
    END IF;
  ELSE
    SELECT 'Valores não podem ser nulos!' AS 'E';
  END IF;
END

$$

DELIMITER $$

CREATE PROCEDURE atualizar_fornecedor(
  IN v_fornecedor INT,
  IN v_nome VARCHAR(100),
  IN v_fone VARCHAR(40),
  IN v_email VARCHAR(100),
  IN v_id INT
  )
BEGIN
  IF ((v_nome != '') && (v_id != '') && (v_fornecedor != '')) THEN
    IF verifica_existencia_fornecedor(v_fornecedor, v_id) THEN  
      IF verifica_existencia_empresa(v_id) THEN  
        UPDATE fornecedores 
          SET fornecedor = v_nome,
            fone = v_fone,
            email = v_email,
            data_atualizado = NOW()
            WHERE id_fornecedor = v_fornecedor AND empresa = v_id;
        SELECT * FROM lista_fornecedores WHERE id_fornecedor = v_fornecedor AND empresa = v_id;
      ELSE
        SELECT 'Empresa não existe!' AS 'E';
      END IF;
    ELSE
        SELECT 'Fornecedor não existe!' AS 'E';
    END IF;
  ELSE
    SELECT 'Valores não podem ser nulos!' AS 'E';
  END IF;
END

$$

DELIMITER $$

CREATE PROCEDURE deletar_fornecedor(
  IN v_fornecedor INT,
  IN v_id INT
  )
BEGIN
  IF v_fornecedor != '' THEN
    IF verifica_existencia_empresa(v_id) THEN  
      IF verifica_existencia_fornecedor(v_fornecedor, v_id) THEN
        DELETE FROM fornecedores WHERE id_fornecedor = v_fornecedor AND empresa = v_id;
      ELSE
        SELECT 'Fornecedor não existe!' AS 'E';
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

CREATE PROCEDURE pesquisa_fornecedores(
    IN v_q VARCHAR(200),
    IN v_off INT,
    IN v_row INT,
    IN v_id INT
  )
BEGIN

  SELECT COUNT(*) AS total, v_off offset, v_row row FROM lista_fornecedores WHERE empresa = v_id AND MATCH(nome, email, fone) AGAINST(v_q IN BOOLEAN MODE);
  SELECT * FROM lista_fornecedores WHERE empresa = v_id AND MATCH(nome, email, fone) AGAINST(v_q IN BOOLEAN MODE) LIMIT v_off, v_row;

END

$$

DELIMITER $$

CREATE PROCEDURE lista_fornecedores(
    IN v_off INT,
    IN v_row INT,
    IN v_id INT
  )
BEGIN

  SELECT COUNT(*) AS total, v_off offset, v_row row FROM lista_fornecedores WHERE empresa = v_id;
  SELECT * FROM lista_fornecedores WHERE empresa = v_id LIMIT v_off, v_row;

END

$$

DELIMITER $$

CREATE PROCEDURE pegar_fornecedor(
    IN v_id_fornecedor INT,
    IN v_id INT
  )
BEGIN

    SELECT * FROM fornecedores WHERE id_fornecedor = v_id_fornecedor AND empresa = v_id;
    SELECT * FROM lista_enderecos_fornecedores WHERE empresa = v_id AND endereco_fornecedor = v_id_fornecedor;

END

$$

DELIMITER $$

CREATE PROCEDURE endereco_fornecedor(
    IN v_id_fornecedor INT,
    IN v_id INT
  )
BEGIN

    SELECT * FROM lista_enderecos_fornecedores WHERE empresa = v_id AND endereco_fornecedor = v_id_fornecedor;

END

$$
