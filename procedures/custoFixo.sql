
DELIMITER $$

CREATE PROCEDURE cadastrar_custo(
    IN v_nome VARCHAR(200),
    IN v_valor DECIMAL(10,2),
    IN v_dia_vencimento INT,
    IN v_id INT
  )
BEGIN
  IF ((v_nome != '') && (v_valor != '') && (v_id != '')) THEN
    IF verifica_existencia_empresa(v_id) THEN
        INSERT INTO custos_fixos (nome, valor, dia_vencimento, empresa, data_cadastro) 
        VALUES (v_nome, v_valor, v_dia_vencimento, v_id, NOW());

        SELECT * FROM custos_fixos WHERE id_custo = LAST_INSERT_ID();
      SELECT 'Empresa não existe!' AS 'E';
    END IF;
  ELSE
    SELECT 'Valores não podem ser nulos!' AS 'E';
  END IF;
END

$$


DELIMITER $$

CREATE PROCEDURE atualizar_custo(
    IN v_id_custo INT,
    IN v_nome VARCHAR(200),
    IN v_valor DECIMAL(10,2),
    IN v_dia_vencimento INT,
    IN v_id INT
  )
BEGIN
  IF ((v_nome != '') && (v_valor != '') && (v_id != '') && (v_id_custo != '')) THEN
    IF verifica_existencia_empresa(v_id) THEN
      IF verifica_existencia_custo(v_id_custo, v_id) THEN
          UPDATE custos_fixos 
          SET 
          nome = v_nome,
          valor = v_valor,
          dia_vencimento = v_dia_vencimento,
          data_atualizado = NOW()
          WHERE empresa = v_id AND id_custo = v_id_custo;
      ELSE
        SELECT 'Despesa não existe!' AS 'E';
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

CREATE PROCEDURE deletar_custo(
    IN v_id_custo INT,
    IN v_id INT
  )
BEGIN
  IF ((v_id != '') && (v_id_custo != '')) THEN
    IF verifica_existencia_empresa(v_id) THEN
      IF verifica_existencia_custo(v_id_custo, v_id) THEN
        DELETE FROM custos_fixos WHERE empresa = v_id AND id_custo = v_id_custo;
      ELSE
        SELECT 'Despesa não existe!' AS 'E';
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

CREATE PROCEDURE pegar_custo_fixo(
    IN v_id_custo INT,
    IN v_id INT
  )
BEGIN

    SELECT * FROM custos_fixos WHERE id_empresa = v_id AND id_custo = v_id_custo;

END

$$

DELIMITER $$

CREATE PROCEDURE lista_custo_fixo(
    IN v_id INT
  )
BEGIN

    SELECT COUNT(*) AS total FROM custos_fixos WHERE id_empresa = v_id;
    SELECT * FROM custos_fixos WHERE id_empresa = v_id;

END

$$