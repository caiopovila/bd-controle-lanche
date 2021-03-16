DELIMITER $$

  CREATE FUNCTION verifica_email_empresa(
     v_email VARCHAR(200)
  )
  RETURNS BOOLEAN
  DETERMINISTIC
    BEGIN
        DECLARE ret INT DEFAULT 0;
        
        SELECT COUNT(*) INTO ret  FROM empresas WHERE email = v_email;
          
          IF ret THEN
            RETURN FALSE;
          ELSE
            RETURN TRUE;
          END IF;
    END    
$$

DELIMITER $$

  CREATE FUNCTION verifica_existencia_empresa(
     v_id INT
  )
  RETURNS BOOLEAN
  DETERMINISTIC
    BEGIN
        DECLARE ret INT DEFAULT 0;
        
        SELECT COUNT(*) INTO ret  FROM empresas WHERE id_empresa = v_id;
          
          IF ret THEN
            RETURN TRUE;
          ELSE
            RETURN FALSE;
          END IF;
    END    
$$

DELIMITER $$

  CREATE FUNCTION verifica_existencia_fornecedor(
     v_id INT,
     v_id_empresa INT
  )
  RETURNS BOOLEAN
  DETERMINISTIC
    BEGIN
        DECLARE ret INT DEFAULT 0;
        
        SELECT COUNT(*) INTO ret  FROM fornecedores WHERE id_fornecedor = v_id AND empresa = v_id_empresa;
          
          IF ret THEN
            RETURN TRUE;
          ELSE
            RETURN FALSE;
          END IF;
    END    
$$

DELIMITER $$

  CREATE FUNCTION verifica_existencia_produto(
     v_id INT,
     v_id_empresa INT
  )
  RETURNS BOOLEAN
  DETERMINISTIC
    BEGIN
        DECLARE ret INT DEFAULT 0;
        
        SELECT COUNT(*) INTO ret FROM produtos WHERE id_produto = v_id AND empresa = v_id_empresa;
          
          IF ret THEN
            RETURN TRUE;
          ELSE
            RETURN FALSE;
          END IF;
    END    
$$

DELIMITER $$

  CREATE FUNCTION verifica_existencia_estoque(
     v_id INT,
     v_id_empresa INT
  )
  RETURNS BOOLEAN
  DETERMINISTIC
    BEGIN
        DECLARE ret INT DEFAULT 0;
        
        SELECT COUNT(*) INTO ret FROM estoques WHERE id_estoque = v_id AND empresa = v_id_empresa;
          
          IF ret THEN
            RETURN TRUE;
          ELSE
            RETURN FALSE;
          END IF;
    END    
$$

DELIMITER $$

  CREATE FUNCTION verifica_existencia_cardapio(
     v_id INT,
     v_id_empresa INT
  )
  RETURNS BOOLEAN
  DETERMINISTIC
    BEGIN
        DECLARE ret INT DEFAULT 0;
        
        SELECT COUNT(*) INTO ret FROM cardapios WHERE id_cardapio = v_id AND empresa = v_id_empresa;
          
          IF ret THEN
            RETURN TRUE;
          ELSE
            RETURN FALSE;
          END IF;
    END    
$$

DELIMITER $$

  CREATE FUNCTION verifica_existencia_item(
     v_id INT,
     v_id_empresa INT
  )
  RETURNS BOOLEAN
  DETERMINISTIC
    BEGIN
        DECLARE ret INT DEFAULT 0;
        
        SELECT COUNT(*) INTO ret FROM itens WHERE id_item = v_id AND empresa = v_id_empresa;
          
          IF ret THEN
            RETURN TRUE;
          ELSE
            RETURN FALSE;
          END IF;
    END    
$$

DELIMITER $$

  CREATE FUNCTION verifica_existencia_cliente(
     v_id INT,
     v_id_empresa INT
  )
  RETURNS BOOLEAN
  DETERMINISTIC
    BEGIN
        DECLARE ret INT DEFAULT 0;
        
        SELECT COUNT(*) INTO ret FROM clientes WHERE id_cliente = v_id AND empresa = v_id_empresa;
          
          IF ret THEN
            RETURN TRUE;
          ELSE
            RETURN FALSE;
          END IF;
    END    
$$

DELIMITER $$

  CREATE FUNCTION verifica_existencia_endereco(
     v_id INT,
     v_id_empresa INT
  )
  RETURNS BOOLEAN
  DETERMINISTIC
    BEGIN
        DECLARE ret INT DEFAULT 0;
        
        SELECT COUNT(*) INTO ret FROM enderecos WHERE id_endereco = v_id AND empresa = v_id_empresa;
          
          IF ret THEN
            RETURN TRUE;
          ELSE
            RETURN FALSE;
          END IF;
    END    
$$


DELIMITER $$

  CREATE FUNCTION verifica_existencia_endereco_vendas(
     v_id INT,
     v_id_empresa INT
  )
  RETURNS BOOLEAN
  DETERMINISTIC
    BEGIN
        DECLARE ret INT DEFAULT 0;
        
        SELECT cliente INTO ret FROM vendas WHERE endereco = v_id AND empresa = v_id_empresa;
          
        RETURN ret;
    END    
$$

DELIMITER $$

  CREATE FUNCTION verifica_existencia_frete(
     v_id INT,
     v_id_empresa INT
  )
  RETURNS BOOLEAN
  DETERMINISTIC
    BEGIN
        DECLARE ret INT DEFAULT 0;
        
        SELECT COUNT(*) INTO ret FROM fretes WHERE id_frete = v_id AND empresa = v_id_empresa;
          
          IF ret THEN
            RETURN TRUE;
          ELSE
            RETURN FALSE;
          END IF;
    END    
$$

DELIMITER $$

  CREATE FUNCTION verifica_existencia_venda(
     v_id INT,
     v_id_empresa INT
  )
  RETURNS BOOLEAN
  DETERMINISTIC
    BEGIN
        DECLARE ret INT DEFAULT 0;
        
        SELECT COUNT(*) INTO ret FROM vendas WHERE id_venda = v_id AND empresa = v_id_empresa;
          
          IF ret THEN
            RETURN TRUE;
          ELSE
            RETURN FALSE;
          END IF;
    END    
$$

DELIMITER $$

  CREATE FUNCTION verifica_existencia_funcionario(
     v_id INT,
     v_id_empresa INT
  )
  RETURNS BOOLEAN
  DETERMINISTIC
    BEGIN
        DECLARE ret INT DEFAULT 0;
        
        SELECT COUNT(*) INTO ret FROM funcionarios WHERE id_funcionario = v_id AND empresa = v_id_empresa;
          
          IF ret THEN
            RETURN TRUE;
          ELSE
            RETURN FALSE;
          END IF;
    END    
$$


DELIMITER $$

  CREATE FUNCTION verifica_existencia_custo(
     v_id INT,
     v_id_empresa INT
  )
  RETURNS BOOLEAN
  DETERMINISTIC
    BEGIN
        DECLARE ret INT DEFAULT 0;
        
        SELECT COUNT(*) INTO ret FROM custos_fixos WHERE id_custo = v_id AND empresa = v_id_empresa;
          
          IF ret THEN
            RETURN TRUE;
          ELSE
            RETURN FALSE;
          END IF;
    END    
$$

DELIMITER $$

  CREATE FUNCTION calcular_frete(
     v_id INT,
     v_empresa INT
  )
  RETURNS DECIMAL(5,2)
  DETERMINISTIC
    BEGIN
        DECLARE ret DECIMAL(5,2) DEFAULT 0;
        DECLARE cit VARCHAR(200) DEFAULT '';
        DECLARE bai VARCHAR(200) DEFAULT '';
        
          SELECT cidade, bairro INTO cit, bai FROM enderecos WHERE id_endereco = v_id;
          SELECT preco INTO ret FROM fretes WHERE bairro = bai AND cidade = cit AND empresa = v_empresa;

        RETURN ret;
    END    
$$


DELIMITER $$

  CREATE FUNCTION f_autentica_empresa(
     v_email VARCHAR(200),
     v_senha VARCHAR(200)
  )
  RETURNS BOOLEAN
  DETERMINISTIC
    BEGIN
        DECLARE ret INT DEFAULT 0;
        
        SELECT COUNT(*) INTO ret FROM empresas WHERE email = v_email AND senha = v_senha;
          
          IF ret THEN
            RETURN TRUE;
          ELSE
            RETURN FALSE;
          END IF;
    END    
$$

DELIMITER $$

  CREATE FUNCTION verifica_item_processado(
     v_id_item INT,
     v_id_empresa INT
  )
  RETURNS BOOLEAN
  DETERMINISTIC
    BEGIN
        DECLARE ret INT DEFAULT 0;
        
        SELECT COUNT(*) INTO ret FROM itens WHERE empresa = v_id_empresa AND id_item = v_id_item AND tipo = 2;
          
          IF ret THEN
            RETURN TRUE;
          ELSE
            RETURN FALSE;
          END IF;
    END    
$$

DELIMITER $$

  CREATE FUNCTION verifica_produto_ingrediente(
     v_id_produto INT,
     v_id_empresa INT
  )
  RETURNS BOOLEAN
  DETERMINISTIC
    BEGIN
        DECLARE ret INT DEFAULT 0;
        
        SELECT COUNT(*) INTO ret FROM produtos WHERE empresa = v_id_empresa AND id_produto = v_id_produto AND tipo = 2;
          
          IF ret THEN
            RETURN TRUE;
          ELSE
            RETURN FALSE;
          END IF;
    END    
$$
