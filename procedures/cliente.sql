
DELIMITER $$

CREATE PROCEDURE cadastrar_cliente(
    IN v_nome VARCHAR(100),
    IN v_fone VARCHAR(50),
    IN v_email VARCHAR(100),
    IN v_id INT
  )
BEGIN
  DECLARE l_usu_id INT DEFAULT 0;
  IF ((v_id != '') && (v_nome != '') && (v_fone != '')) THEN
    IF verifica_existencia_empresa(v_id) THEN
      START TRANSACTION;
        
        INSERT INTO clientes (nome, fone, email, empresa, data_cadastro) 
        VALUES (v_nome, v_fone, v_email, v_id, NOW());

	      SET l_usu_id = LAST_INSERT_ID();
        
        SELECT * FROM clientes WHERE id_cliente = l_usu_id;
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

CREATE PROCEDURE atualizar_cliente(
    IN v_id_cliente INT,
    IN v_nome VARCHAR(200),
    IN v_fone VARCHAR(50),
    IN v_email VARCHAR(200),
    IN v_id INT
  )
BEGIN
  IF ((v_id != '') && (v_nome != '') && (v_fone != '') && (v_id_cliente != '')) THEN
    IF verifica_existencia_empresa(v_id) THEN
      IF verifica_existencia_cliente(v_id_cliente, v_id) THEN
          UPDATE clientes 
          SET 
            nome = v_nome,
            fone = v_fone,
            email = v_email,
            data_atualizado = NOW()
          WHERE id_cliente = v_id_cliente AND empresa = v_id;
      ELSE
        SELECT 'Cliente não existe!' AS 'E';
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

CREATE PROCEDURE deletar_cliente(
    IN v_id_cliente INT,
    IN v_id INT
  )
BEGIN
  IF ((v_id != '') && (v_id_cliente != '')) THEN
    IF verifica_existencia_empresa(v_id) THEN
      IF verifica_existencia_cliente(v_id_cliente, v_id) THEN
        DELETE FROM clientes WHERE id_cliente = v_id_cliente AND empresa = v_id ;
      ELSE
        SELECT 'Cliente não existe!' AS 'E';
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

CREATE PROCEDURE pesquisa_clientes(
    IN v_q VARCHAR(200),
    IN v_off INT,
    IN v_row INT,
    IN v_id INT
  )
BEGIN

  SELECT COUNT(*) AS total, v_off offset, v_row linha FROM lista_clientes WHERE empresa = v_id AND MATCH(nome, fone, email) AGAINST(v_q IN BOOLEAN MODE);
  SELECT * FROM lista_clientes WHERE empresa = v_id AND MATCH(nome, fone, email) AGAINST(v_q IN BOOLEAN MODE) LIMIT v_off, v_row;

END

$$

DELIMITER $$

CREATE PROCEDURE lista_clientes(
    IN v_off INT,
    IN v_row INT,
    IN v_id INT
  )
BEGIN

  SELECT COUNT(*) AS total, v_off offset, v_row linha FROM lista_clientes WHERE empresa = v_id;
  SELECT * FROM lista_clientes WHERE empresa = v_id LIMIT v_off, v_row;

END

$$

DELIMITER $$

CREATE PROCEDURE pegar_cliente(
    IN v_id_cliente INT,
    IN v_id INT
  )
BEGIN

    SELECT * FROM clientes WHERE id_cliente = v_id_cliente AND empresa = v_id;
    SELECT * FROM lista_enderecos_clientes WHERE endereco_cliente = v_id_cliente AND empresa = v_id;

END

$$

DELIMITER $$

CREATE PROCEDURE pegar_enderecos_cliente(
    IN v_id_cliente INT,
    IN v_id INT
  )
BEGIN

    SELECT * FROM lista_enderecos_clientes WHERE endereco_cliente = v_id_cliente AND empresa = v_id;

END

$$