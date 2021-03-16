DELIMITER $$

CREATE PROCEDURE cadastrar_estoque(
  IN v_quantidade INT,
  IN v_peso DECIMAL(10,5),
  IN v_unidade_medida VARCHAR(5),
  IN v_fornecedor INT,
  IN v_id INT,
  IN v_id_produto INT
  )
BEGIN
  DECLARE id_generete INT DEFAULT 0;
  IF ((v_id != '') && (v_id_produto != '')) THEN
    IF verifica_existencia_empresa(v_id) THEN 
      IF verifica_existencia_produto(v_id_produto, v_id) THEN 
        START TRANSACTION;
          INSERT INTO estoques (quantidade, peso_unitario, unidade_medida, fornecedor, empresa, produto, data_cadastro) 
          VALUES (v_quantidade, v_peso, v_unidade_medida, v_fornecedor, v_id, v_id_produto, NOW());
          SET id_generete = LAST_INSERT_ID();
          SELECT * FROM detalhes_produtos WHERE id_estoque = id_generete;
        COMMIT;
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

CREATE PROCEDURE atualizar_estoque(
  IN v_id_estoque INT,
  IN v_quantidade INT,
  IN v_peso DECIMAL(10,5),
  IN v_unidade_medida VARCHAR(5),
  IN v_fornecedor INT,
  IN v_id INT,
  IN v_id_produto INT
  )
BEGIN
  IF ((v_id != '') && (v_id_produto != '') && (v_id_estoque != '')) THEN
    IF verifica_existencia_empresa(v_id) THEN 
      IF verifica_existencia_produto(v_id_produto, v_id) THEN 
          IF verifica_existencia_estoque(v_id_estoque, v_id) THEN
            UPDATE estoques 
            SET quantidade = v_quantidade,
                peso_unitario = v_peso,
                unidade_medida = v_unidade_medida,
                fornecedor = v_fornecedor,
                produto = v_id_produto,
                data_atualizado = NOW() 
            WHERE id_estoque = v_id_estoque AND empresa = v_id;
          ELSE
            SELECT 'Estoque não existe!' AS 'E';  
          END IF;
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

CREATE PROCEDURE deletar_estoque(
  IN v_id_estoque INT,
  IN v_id INT
  )
BEGIN
  IF ((v_id != '') && (v_id_estoque != '')) THEN
    IF verifica_existencia_empresa(v_id) THEN 
      IF verifica_existencia_estoque(v_id_estoque, v_id) THEN
        DELETE FROM estoques WHERE id_estoque = v_id_estoque AND empresa = v_id;
      ELSE
        SELECT 'Estoque não existe!' AS 'E';  
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

CREATE PROCEDURE movimetar_estoque(
  IN v_entrada INT,
  IN v_saida INT,
  IN v_id INT,
  IN v_id_estoque INT
  )
BEGIN
  IF ((v_id != '') && (v_id_estoque != '')) THEN
    IF verifica_existencia_empresa(v_id) THEN 
      IF verifica_existencia_estoque(v_id_estoque, v_id) THEN 
        START TRANSACTION;
          INSERT INTO controle_estoques (entrada, saida, estoque, empresa, data_registro) 
          VALUES (v_entrada, v_saida, v_id_estoque, v_id, NOW());
          SELECT * FROM detalhes_produtos WHERE id_estoque = id_generete;
        COMMIT;
      ELSE
          SELECT 'Estoque não existe!' AS 'E';
      END IF;
    ELSE
      SELECT 'Empresa não existe!' AS 'E';
    END IF;
  ELSE
    SELECT 'Valores não podem ser nulos!' AS 'E';
  END IF;
END

$$