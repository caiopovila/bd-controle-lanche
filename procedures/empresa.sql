
DELIMITER $$

CREATE PROCEDURE cadastrar_empresa(
  IN v_nome VARCHAR(100),
  IN v_email VARCHAR(100),
  IN v_senha VARCHAR(50),
  IN v_fone VARCHAR(50)
  )
BEGIN
  DECLARE emp_id INT DEFAULT 0;
  IF ((v_nome != '') && (v_email != '') && (v_senha != '')) THEN
    IF verifica_email_empresa(v_email) THEN  
      START TRANSACTION;
        INSERT INTO empresas (nome, email, senha, fone, data_cadastro) VALUES (v_nome, v_email, v_senha, v_fone, NOW());
        SET emp_id = LAST_INSERT_ID();

        IF emp_id > 0 THEN
          INSERT INTO privilegio_empresas (privilegio, empresa) VALUES ('normal', emp_id);
        END IF;
        
        SELECT * FROM lista_empresas WHERE id_empresa = emp_id;
      COMMIT;
    ELSE
      SELECT 'Email já existente!' AS 'E';
    END IF;
  ELSE
    SELECT 'Valores não podem ser nulos!' AS 'E';
  END IF;
END

$$

DELIMITER $$

CREATE PROCEDURE atualizar_empresa(
  IN v_nome VARCHAR(100),
  IN v_email VARCHAR(100),
  IN v_senha VARCHAR(50),
  IN v_fone VARCHAR(50),
  IN v_id INT
  )
BEGIN
  DECLARE msm_email INT DEFAULT 0;
  IF ((v_nome != '') && (v_email != '') && (v_id != '')) THEN
    IF verifica_existencia_empresa(v_id) THEN
      SELECT COUNT(*) INTO msm_email FROM empresas WHERE email = v_email AND id_empresa = v_id; 
      IF msm_email THEN
        IF v_senha != '' THEN
          UPDATE empresas SET nome = v_nome, senha = v_senha, fone = v_fone, data_atualizado = NOW()
          WHERE id_empresa = v_id;
        ELSE
          UPDATE empresas SET nome = v_nome, fone = v_fone, data_atualizado = NOW()
          WHERE id_empresa = v_id;
        END IF;
      ELSE
        IF verifica_email_empresa(v_email) THEN  
        IF v_senha != '' THEN
          UPDATE empresas SET nome = v_nome, email = v_email, senha = v_senha, fone = v_fone, data_atualizado = NOW()
          WHERE id_empresa = v_id;
        ELSE
          UPDATE empresas SET nome = v_nome, email = v_email, fone = v_fone, data_atualizado = NOW()
          WHERE id_empresa = v_id;
        END IF;
        ELSE
          SELECT 'Email já existente!' AS 'E';
        END IF;
      END IF;
      SELECT * FROM lista_empresas WHERE id_empresa = v_id;
    ELSE
      SELECT 'Empresa não existe!' AS 'E';
    END IF;
  ELSE
    SELECT 'Valores não podem ser nulos!' AS 'E';
  END IF;
END

$$

DELIMITER $$

CREATE PROCEDURE alterar_privilegio_empresa(
  IN v_privilegio VARCHAR(10),
  IN v_id INT
  )
BEGIN
  DECLARE msm_email INT DEFAULT 0;
  IF ((v_privilegio != '') && (v_id != '')) THEN
    IF verifica_existencia_empresa(v_id) THEN
      UPDATE privilegio_empresas SET privilegio = v_privilegio, data_atualizado = NOW()
      WHERE empresa = v_id;
    ELSE
      SELECT 'Empresa não existe!' AS 'E';
    END IF;
  ELSE
    SELECT 'Valores não podem ser nulos!' AS 'E';
  END IF;
END

$$

DELIMITER $$

CREATE PROCEDURE deletar_empresa(
  IN v_id INT
  )
BEGIN
  IF v_id != '' THEN
    IF verifica_existencia_empresa(v_id) THEN
      DELETE FROM empresas WHERE id_empresa = v_id;
    ELSE
      SELECT 'Empresa não existe!' AS 'E';
    END IF;
  ELSE
    SELECT 'Valores não podem ser nulos!' AS 'E';
  END IF;
END

$$

/* Auth */
DELIMITER $$

CREATE PROCEDURE autentica_empresa(
    IN v_email VARCHAR(200),
    IN v_senha VARCHAR(200)
  )
BEGIN
  IF ((v_email != '') && (v_senha != '')) THEN
    IF f_autentica_empresa(v_email, v_senha) THEN
      SELECT * FROM lista_empresas WHERE email = v_email;
    ELSE
      SELECT 'Email e/ou senha incorreto!' AS 'E';
    END IF;
  ELSE
    SELECT 'Valores não podem ser nulos!' AS 'E';
  END IF;
END

$$

/* search */
DELIMITER $$

CREATE PROCEDURE pesquisa_empresa(
    IN v_q VARCHAR(200),
    IN v_off INT,
    IN v_row INT
  )
BEGIN

  SELECT COUNT(*) AS total FROM lista_empresas WHERE MATCH(nome, email) AGAINST(v_q IN BOOLEAN MODE);
  SELECT v_off offset, v_row linha;
  SELECT * FROM lista_empresas WHERE MATCH(nome, email) AGAINST(v_q IN BOOLEAN MODE) LIMIT v_off, v_row;

END

$$

DELIMITER $$

CREATE PROCEDURE pegar_empresa(
    IN v_id INT
  )
BEGIN

    SELECT * FROM lista_empresas WHERE id_empresa = v_id;
    SELECT * FROM lista_enderecos_empresas WHERE endereco_empresa = v_id;
    SELECT * FROM privilegio_empresas WHERE empresa = v_id;

END

$$

DELIMITER $$

CREATE PROCEDURE pegar_privilegio(
    IN v_id INT
  )
BEGIN

    SELECT * FROM privilegio_empresas WHERE empresa = v_id;

END

$$

DELIMITER $$

CREATE PROCEDURE pegar_endereco_empresa(
    IN v_id INT
  )
BEGIN

    SELECT * FROM lista_enderecos_empresas WHERE empresa = v_id AND endereco_empresa = v_id;

END

$$