
DELIMITER $$

CREATE PROCEDURE cadastrar_venda(
    IN v_endereco INT,
    IN v_frete DECIMAL(5,2),
    IN v_desconto DECIMAL(5,2),
    IN v_cliente INT,
    IN v_id INT
  )
BEGIN
  IF ((v_cliente != '') && (v_endereco != '') && (v_id != '')) THEN
    IF verifica_existencia_empresa(v_id) THEN
      IF verifica_existencia_cliente(v_cliente, v_id) THEN
        IF verifica_existencia_endereco(v_endereco, v_id) THEN
            INSERT INTO vendas (endereco, frete, desconto, progresso, preco_total, cliente, empresa, data_criado) 
            VALUES (v_endereco, v_frete, v_desconto, 'producao', 0, v_cliente, v_id, NOW());

            SELECT * FROM vendas WHERE id_venda = LAST_INSERT_ID();
        ELSE
          SELECT 'Endereço não existe!' AS 'E';
        END IF;
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

CREATE PROCEDURE add_item_venda(
    IN v_item INT,
    IN v_venda INT,
    IN v_nome VARCHAR(100),
    IN v_preco DECIMAL(10,2),
    IN v_id INT
  )
BEGIN
  IF ((v_item != '') && (v_venda != '')) THEN
    IF verifica_existencia_venda(v_venda, v_id) THEN
      IF verifica_existencia_item(v_item, v_id) THEN
        INSERT INTO itens_venda (item, venda, nome, preco)  VALUES (v_item, v_venda, v_nome, v_preco);
      ELSE
        SELECT 'Item não existe!' AS 'E';
      END IF;
    ELSE
      SELECT 'Venda não existe!' AS 'E';
    END IF;
  ELSE
    SELECT 'Valores não podem ser nulos!' AS 'E';
  END IF;
END

$$

DELIMITER $$

CREATE PROCEDURE remover_item_venda(
    IN v_item INT,
    IN v_venda INT,
    IN v_id INT
  )
BEGIN
  IF ((v_item != '') && (v_venda != '')) THEN
    IF verifica_existencia_venda(v_venda, v_id) THEN
        DELETE FROM itens_venda WHERE id = v_item AND venda = v_venda;
    ELSE
      SELECT 'Venda não existe!' AS 'E';
    END IF;
  ELSE
    SELECT 'Valores não podem ser nulos!' AS 'E';
  END IF;
END

$$

DELIMITER $$

CREATE PROCEDURE atualizar_venda(
    IN v_id_venda INT,
    IN v_endereco INT,
    IN v_desconto DECIMAL(5,2),
    IN v_progresso INT,
    IN v_frete DECIMAL(5,2),
    IN v_cliente INT,
    IN v_id INT
  )
BEGIN
  IF ((v_cliente != '') && (v_id != '') && (v_id_venda != '')) THEN
    IF verifica_existencia_empresa(v_id) THEN
      IF verifica_existencia_cliente(v_cliente, v_id) THEN
        IF verifica_existencia_endereco(v_endereco, v_id) THEN
          IF verifica_existencia_venda(v_id_venda, v_id) THEN
            UPDATE vendas 
            SET 
            endereco = v_endereco,
            frete = v_frete,
            desconto = v_desconto,
            progresso = v_progresso,
            cliente = v_cliente,
            data_atualizado = NOW()
            WHERE empresa = v_id AND id_venda = v_id_venda;
          ELSE
            SELECT 'Venda não existe!' AS 'E';
          END IF;
        ELSE
          SELECT 'Endereço não existe!' AS 'E';
        END IF;
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

CREATE PROCEDURE deletar_venda(
    IN v_id_venda INT,
    IN v_id INT
  )
BEGIN
  IF ((v_id_venda != '') && (v_id != '')) THEN
    IF verifica_existencia_empresa(v_id) THEN
      IF verifica_existencia_venda(v_id_venda, v_id) THEN
        DELETE FROM vendas WHERE empresa = v_id AND id_venda = v_id_venda;
      ELSE
        SELECT 'Venda não existe!' AS 'E';
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

CREATE PROCEDURE lista_vendas(
    IN v_off INT,
    IN v_row INT,
    IN v_id INT
  )
BEGIN

  SELECT COUNT(*) AS total, v_off offset, v_row linha FROM lista_vendas WHERE empresa = v_id;
  SELECT * FROM lista_vendas WHERE empresa = v_id ORDER BY data_criado LIMIT v_off, v_row;

END

$$

DELIMITER $$

CREATE PROCEDURE lista_vendas_aberto(
    IN v_off INT,
    IN v_row INT,
    IN v_id INT
  )
BEGIN

  SELECT COUNT(*) AS total, v_off offset, v_row linha FROM lista_vendas WHERE empresa = v_id AND (progresso = 'producao' OR progresso = 'despachado');
  SELECT * FROM lista_vendas WHERE empresa = v_id AND (progresso = 'producao' OR progresso = 'despachado') ORDER BY data_criado LIMIT v_off, v_row;

END

$$

DELIMITER $$

CREATE PROCEDURE item_venda(
    IN v_id_venda INT,
    IN v_id INT
  )
BEGIN

  SELECT * FROM lista_itens_venda WHERE venda = v_id_venda AND empresa = v_id;

END

$$