
DELIMITER $$

CREATE PROCEDURE cadastrar_funcionario(
    IN v_nome VARCHAR(200),
    IN v_funcao VARCHAR(200),
    IN v_salario DECIMAL(10,2),
    IN v_dia_pagamento INT,
    IN v_id INT
  )
BEGIN
  IF ((v_nome != '') && (v_salario != '') && (v_funcao != '') && (v_id != '')) THEN
    IF verifica_existencia_empresa(v_id) THEN
        INSERT INTO funcionarios (nome, funcao, salario, dia_pagamento, empresa, data_cadastro) 
        VALUES (v_nome, v_funcao, v_salario, v_dia_pagamento, v_id, NOW());

        SELECT * FROM funcionarios WHERE id_funcionario = LAST_INSERT_ID();
      SELECT 'Empresa não existe!' AS 'E';
    END IF;
  ELSE
    SELECT 'Valores não podem ser nulos!' AS 'E';
  END IF;
END

$$


DELIMITER $$

CREATE PROCEDURE atualizar_funcionario(
    IN v_id_funcionario INT,
    IN v_nome VARCHAR(200),
    IN v_funcao VARCHAR(200),
    IN v_salario DECIMAL(10,2),
    IN v_dia_pagamento INT,
    IN v_id INT
  )
BEGIN
  IF ((v_nome != '') && (v_salario != '') && (v_funcao != '') && (v_id != '') && (v_id_funcionario != '')) THEN
    IF verifica_existencia_empresa(v_id) THEN
      IF verifica_existencia_funcionario(v_id_funcionario, v_id) THEN
          UPDATE funcionarios 
          SET 
          nome = v_nome,
          funcao = v_funcao,
          salario = v_salario,
          dia_pagamento = v_dia_pagamento,
          data_atualizado = NOW()
          WHERE empresa = v_id AND id_funcionario = v_id_funcionario;
      ELSE
        SELECT 'Funcionario não existe!' AS 'E';
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

CREATE PROCEDURE deletar_funcionario(
    IN v_id_func INT,
    IN v_id INT
  )
BEGIN
  IF ((v_id_func != '') && (v_id != '')) THEN
    IF verifica_existencia_empresa(v_id) THEN
      IF verifica_existencia_funcionario(v_id_func, v_id) THEN
        DELETE FROM funcionarios WHERE empresa = v_id AND id_funcionario = v_id_func;
      ELSE
        SELECT 'Funcionario não existe!' AS 'E';
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

CREATE PROCEDURE pegar_funcionario(
    IN v_id_func INT,
    IN v_id INT
  )
BEGIN
    SELECT * FROM funcionarios WHERE id_empresa = v_id AND id_funcionario = v_id_func;
END

$$

DELIMITER $$

CREATE PROCEDURE lista_funcionario(
    IN v_id INT
  )
BEGIN
    SELECT * FROM funcionarios WHERE id_empresa = v_id;
END

$$