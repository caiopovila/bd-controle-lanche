DELIMITER $$

CREATE PROCEDURE cadastrar_endereco(
    IN v_rua VARCHAR(200),
    IN v_numero INT,
    IN v_bairro VARCHAR(200),
    IN v_cidade VARCHAR(200),
    IN v_cep VARCHAR(100),
    IN v_id INT
  )
BEGIN
  DECLARE id_generete INT DEFAULT 0;
  IF ((v_numero != '') && (v_rua != '') && (v_bairro != '') && (v_id != '')) THEN
    IF verifica_existencia_empresa(v_id) THEN
	    START TRANSACTION;
	      INSERT INTO enderecos (rua, numero, bairro, cidade, cep, empresa, data_cadastro) 
	      VALUES (v_rua, v_numero, v_bairro, v_cidade, v_cep, v_id, NOW());
	      SET id_generete = LAST_INSERT_ID();
	      SELECT * FROM enderecos WHERE id_endereco = id_generete;
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

CREATE PROCEDURE atualizar_endereco(
    IN v_id_endereco INT,
    IN v_rua VARCHAR(200),
    IN v_numero INT,
    IN v_bairro VARCHAR(200),
    IN v_cidade VARCHAR(200),
    IN v_cep VARCHAR(100),
    IN v_id INT
  )
BEGIN
  IF ((v_numero != '') && (v_rua != '') && (v_bairro != '') && (v_id_endereco != '')) THEN
    IF verifica_existencia_empresa(v_id) THEN
      IF verifica_existencia_endereco(v_id_endereco, v_id) THEN
        UPDATE enderecos 
        SET 
          rua = v_rua,
          numero = v_numero,
          bairro = v_bairro,
          cidade = v_cidade,
          cep = v_cep,
          data_atualizado = NOW()
        WHERE id_endereco = v_id_endereco AND empresa = v_id;
      ELSE
        SELECT 'Endereço não existe!' AS 'E';
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

CREATE PROCEDURE add_endereco_cliente(
    IN v_endereco INT,
    IN v_cliente INT,
    IN v_id INT
  )
BEGIN
  IF ((v_endereco != '') && (v_cliente != '')) THEN
    IF verifica_existencia_endereco(v_endereco, v_id) THEN
      IF verifica_existencia_cliente(v_cliente, v_id) THEN
        INSERT INTO enderecos_clientes (endereco, cliente) VALUES (v_endereco, v_cliente);
      ELSE
        SELECT 'Cliente não existe!' AS 'E';
      END IF;
    ELSE
      SELECT 'Endereço não existe!' AS 'E';
    END IF;
  ELSE
    SELECT 'Valores não podem ser nulos!' AS 'E';
  END IF;
END

$$

DELIMITER $$

CREATE PROCEDURE add_endereco_fornecedor(
    IN v_endereco INT,
    IN v_fornecedor INT,
    IN v_id INT
  )
BEGIN
  IF ((v_endereco != '') && (v_fornecedor != '')) THEN
    IF verifica_existencia_endereco(v_endereco, v_id) THEN
      IF verifica_existencia_fornecedor(v_fornecedor, v_id) THEN
        INSERT INTO enderecos_fornecedores (endereco, fornecedor) VALUES (v_endereco, v_fornecedor);
      ELSE
        SELECT 'Cliente não existe!' AS 'E';
      END IF;
    ELSE
      SELECT 'Endereço não existe!' AS 'E';
    END IF;
  ELSE
    SELECT 'Valores não podem ser nulos!' AS 'E';
  END IF;
END

$$

DELIMITER $$

CREATE PROCEDURE add_endereco_empresa(
    IN v_endereco INT,
    IN v_empresa INT
  )
BEGIN
  IF ((v_endereco != '') && (v_empresa != '')) THEN
    IF verifica_existencia_endereco(v_endereco, v_empresa) THEN
      IF verifica_existencia_empresa(v_empresa) THEN
        INSERT INTO enderecos_empresas (endereco, empresa) VALUES (v_endereco, v_empresa);
      ELSE
        SELECT 'Empresa não existe!' AS 'E';
      END IF;
    ELSE
      SELECT 'Endereço não existe!' AS 'E';
    END IF;
  ELSE
    SELECT 'Valores não podem ser nulos!' AS 'E';
  END IF;
END

$$

DELIMITER $$

CREATE PROCEDURE deletar_endereco(
    IN v_id_endereco INT,
    IN v_id INT
  )
BEGIN
    DECLARE ret INT DEFAULT 0;
  IF v_id_endereco != '' THEN
    IF verifica_existencia_endereco(v_id_endereco, v_id) THEN
        SET ret = verifica_existencia_endereco_vendas(v_id_endereco, v_id);
       IF ret > 0 THEN
            DELETE FROM enderecos_clientes WHERE endereco = v_id_endereco AND cliente = ret;    
        ELSE
             DELETE FROM enderecos WHERE id_endereco = v_id_endereco AND empresa = v_id;
        END IF;
    ELSE
      SELECT 'Endereço não existe!' AS 'E';
    END IF;
  ELSE
    SELECT 'Valores não podem ser nulos!' AS 'E';
  END IF;
END

$$

/* search */
DELIMITER $$

CREATE PROCEDURE pesquisa_enderecos(
    IN v_q VARCHAR(200),
    IN v_off INT,
    IN v_row INT,
    IN v_id INT
  )
BEGIN

  SELECT COUNT(*) AS total, v_off offset, v_row linha FROM lista_enderecos WHERE empresa = v_id AND MATCH(rua, bairro, cidade, cep) AGAINST(v_q IN BOOLEAN MODE);
  SELECT * FROM lista_enderecos WHERE empresa = v_id AND MATCH(rua, bairro, cidade, cep) AGAINST(v_q IN BOOLEAN MODE) LIMIT v_off, v_row;

END

$$

DELIMITER $$

CREATE PROCEDURE pegar_endereco(
    IN v_id_endereco INT,
    IN v_id INT
  )
BEGIN

    SELECT * FROM enderecos WHERE id_endereco = v_id_endereco AND empresa = v_id;

END

$$