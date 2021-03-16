
DELIMITER $$

CREATE PROCEDURE cadastrar_registro(
  IN v_registro VARCHAR(400),
  IN v_empresa VARCHAR(100)
  )
BEGIN
        INSERT INTO registros (registro, empresa, data_cadastro) 
        VALUES (v_registro, v_empresa, NOW());
END

$$


DELIMITER $$

CREATE PROCEDURE pesquisa_registro(
    IN v_q VARCHAR(200),
    IN v_off INT,
    IN v_row INT
  )
BEGIN

  SELECT COUNT(*) AS total, v_off offset, v_row linha FROM registros WHERE MATCH(registro) AGAINST(v_q IN BOOLEAN MODE);
  SELECT * FROM registros WHERE MATCH(registro) AGAINST(v_q IN BOOLEAN MODE) LIMIT v_off, v_row;

END

$$