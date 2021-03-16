CREATE VIEW lista_empresas
AS 
SELECT 
    id_empresa,
    nome, 
    email, 
    fone
FROM
    empresas;

CREATE VIEW lista_enderecos_empresas
AS
SELECT
    id_endereco,
    rua,
    numero,
    bairro,
    cidade,
    cep,
    ee.empresa endereco_empresa
FROM
    enderecos e
INNER JOIN enderecos_empresas ee ON e.id_endereco = ee.endereco;

CREATE VIEW lista_itens
AS 
SELECT 
    id_item,
    nome, 
    descricao, 
    preco,
    empresa
FROM
    itens;

CREATE VIEW lista_clientes
AS 
SELECT 
    id_cliente,
    nome, 
    fone, 
    email,
    empresa
FROM
    clientes;

CREATE VIEW lista_enderecos_clientes
AS 
SELECT 
    id_endereco,
    rua,
    numero,
    bairro,
    cidade,
    cep,
    e.empresa,
    ec.cliente endereco_cliente
FROM
    enderecos e
INNER JOIN enderecos_clientes ec ON e.id_endereco = ec.endereco;

CREATE VIEW lista_itens_cardapio
AS 
SELECT 
    i.id_item,
    nome, 
    descricao, 
    preco,
    empresa,
    ic.id_cardapio
FROM
    itens i
LEFT JOIN itens_cardapios ic ON i.id_item = ic.id_item;


CREATE VIEW lista_produtos
AS 
SELECT 
    p.id_produto,
    p.produto, 
    marca, 
    descricao,
    tipo,
    preco_unitario,
    p.empresa,
    peso_unitario,
    quantidade,
    f.id_fornecedor,
    f.fornecedor,
    unidade_medida,
    e.id_estoque
FROM
    produtos p
LEFT JOIN estoques e ON e.produto = p.id_produto
LEFT JOIN fornecedores f ON e.fornecedor = f.id_fornecedor;

CREATE VIEW lista_cardapios
AS 
SELECT 
    id_cardapio,
    nome, 
    descricao,
    empresa
FROM
    cardapios;



CREATE VIEW lista_produtos_itens
AS 
SELECT 
    id,
    p.id_produto,
    produto, 
    marca,
    preco_unitario,
    empresa,
    id_item,
    peso_quantidade,
    unidade_medida
FROM
    produtos p
INNER JOIN produtos_itens pi ON p.id_produto = pi.id_produto;



CREATE VIEW lista_itens_produtos
AS 
SELECT 
    id,
    i.id_item,
    nome, 
    descricao,
    preco,
    empresa,
    id_produto,
    peso_quantidade,
    unidade_medida
FROM
    itens i
INNER JOIN produtos_itens pi ON i.id_item = pi.id_item;

CREATE VIEW lista_fornecedores
AS 
SELECT 
    id_fornecedor,
    fornecedor nome, 
    fone,
    email,
    empresa
FROM
    fornecedores;


CREATE VIEW lista_enderecos_fornecedores
AS 
SELECT 
    id_endereco,
    rua, 
    numero,
    bairro,
    cidade,
    cep,
    empresa,
    ef.fornecedor endereco_fornecedor
FROM
    enderecos
INNER JOIN enderecos_fornecedores ef ON id_endereco = ef.endereco;


CREATE VIEW lista_vendas
AS
SELECT
    v.id_venda,
    v.endereco,
    v.frete,
    v.progresso,
    v.preco_total,
    v.cliente,
    v.data_criado,
    v.data_atualizado,
    v.empresa,
    c.nome,
    c.fone,
    c.email
FROM 
    vendas v
INNER JOIN clientes c ON c.id_cliente = cliente;
 

CREATE VIEW lista_itens_venda
AS 
SELECT 
    id,
    iv.item id_item,
    iv.venda,
    iv.nome, 
    iv.preco,
    descricao,
    empresa
FROM
    itens_venda iv 
LEFT JOIN itens i ON id_item = item;



CREATE VIEW lista_fretes
AS 
SELECT 
  id_frete,
  bairro,
  cidade,
  preco,
  empresa
FROM
    fretes;



/* CURVA ABC */
CREATE VIEW total_produto
AS    
SELECT id_produto, empresa, preco_unitario * quantidade valor_total FROM lista_produtos WHERE tipo = 1 ORDER BY valor_total DESC;

CREATE VIEW total_acumulado
AS
SELECT id_produto, valor_total, empresa, SUM(valor_total) OVER (PARTITION BY empresa ORDER BY valor_total DESC) acumulado FROM total_produto;

CREATE VIEW por_acumulado
AS
SELECT id_produto, valor_total, empresa, acumulado, CAST(acumulado * 100 / MAX(acumulado)OVER(PARTITION BY empresa) AS DECIMAL(10,2)) porcentagem_ac FROM total_acumulado ORDER BY valor_total DESC;

CREATE VIEW curva_produtos
AS
SELECT id_produto, valor_total, acumulado, empresa, porcentagem_ac, CASE WHEN porcentagem_ac < 70 THEN 'A' WHEN porcentagem_ac < 90 THEN 'B' ELSE 'C' END AS curva FROM por_acumulado;


CREATE VIEW detalhes_produtos
AS
SELECT 	c.id_produto, 
	c.produto, 
	c.marca, 
	c.descricao,
	c.tipo,
	c.preco_unitario,
	c.empresa,
	c.peso_unitario,
	c.quantidade,
	c.id_fornecedor,
	c.fornecedor,
	c.unidade_medida,
	c.id_estoque,
	d.valor_total,
	d.curva
FROM lista_produtos c
LEFT JOIN curva_produtos d ON c.id_produto = d.id_produto;

/*

        ANALISE CUSTO/VOLUME/LUCRO - MENSAL

        - MARGEM DE CONTRIBUIÇÃO 

        - PONTO DE EQUILIBRIO

        - MARGEM DE SEGURANÇA

*/


                    /* - MARGEM DE CONTRIBUIÇÃO */

/* Custo do produto sobre o item */
CREATE VIEW lista_itens_produtos_custo
AS
SELECT ip.empresa, id, p.preco_unitario, peso_quantidade, peso_unitario peso_estoque, p.id_produto, p.produto produto, ip.id_item, ip.nome item, ip.preco preco_item, CAST((p.preco_unitario * peso_quantidade / peso_unitario) AS DECIMAL(10,2)) AS custo_produto FROM lista_produtos p
INNER JOIN lista_itens_produtos ip ON ip.id_produto = p.id_produto;

CREATE VIEW lista_itens_produtos_custo_unitario
AS
SELECT *, SUM(custo_produto) OVER(PARTITION BY id_item) custo_unitario FROM lista_itens_produtos_custo;

CREATE VIEW lista_itens_produtos_custo_unitario_M_C_U
AS
SELECT *, preco_item - custo_unitario M_C_U FROM lista_itens_produtos_custo_unitario;

CREATE VIEW lista_itens_produtos_custo_unitario_M_C_U_P
AS
SELECT *, CAST((M_C_U / preco_item * 100) AS DECIMAL(10,2)) AS M_C_U_P FROM lista_itens_produtos_custo_unitario_M_C_U;

CREATE VIEW total_vendas_itens_mes
AS
SELECT distinct lista_itens_venda.id_item, nome, preco, lista_itens_venda.empresa, COUNT(*) OVER (PARTITION BY id_item) Vendas FROM lista_itens_venda
INNER JOIN vendas ON id_venda = venda WHERE progresso = 'entregue' AND DATE(data_criado) BETWEEN CAST(CONCAT(YEAR(CURDATE()), '-', MONTH(CURDATE()) - 1, '-', DAY(CURDATE())) AS DATE) AND CAST(CURDATE() AS DATE);

CREATE VIEW lista_itens_produtos_custo_total
AS
SELECT pc.*, vendas * custo_unitario AS custo_total, vendas * preco AS receita FROM lista_itens_produtos_custo_unitario pc
INNER JOIN total_vendas_itens_mes vi ON vi.id_item = pc.id_item;

CREATE VIEW custos_receita
AS
SELECT distinct pc.empresa, pc.id_item, item, vendas * custo_unitario AS custo_total, vendas * preco AS receita FROM lista_itens_produtos_custo_unitario pc
INNER JOIN total_vendas_itens_mes vi ON vi.id_item = pc.id_item;

CREATE VIEW receita_total
AS
SELECT distinct empresa, SUM(receita) OVER(PARTITION BY empresa) AS receita_vendas FROM custos_receita;

CREATE VIEW custos_receita_p
AS
SELECT custos_receita.empresa, id_item, item, receita, CAST((receita / receita_vendas) AS DECIMAL(5,2)) AS 'receita_p' FROM custos_receita
INNER JOIN receita_total ON receita_total.empresa = custos_receita.empresa;

CREATE VIEW lista_itens_M_C_T
AS
SELECT distinct id_item, empresa, item, receita, custo_total, custo_unitario, receita - custo_total AS 'M_C_T' FROM lista_itens_produtos_custo_total;

CREATE VIEW lucro_vendas_custo_producao
AS
SELECT distinct empresa, SUM(M_C_T) OVER(PARTITION BY empresa) lucro, SUM(custo_total) OVER(PARTITION BY empresa) dispesas_producao FROM lista_itens_M_C_T;

                    /* - PONTO DE EQUILÍBRIO */

CREATE VIEW total_fixos
AS
SELECT distinct empresa, SUM(CAST(valor AS DECIMAL(10,2))) OVER (PARTITION BY empresa) AS total_fixos FROM custos_fixos;

CREATE VIEW total_salarios
AS
SELECT distinct empresa, SUM(CAST(salario AS DECIMAL(10,2))) OVER (PARTITION BY empresa) AS total_salarios FROM funcionarios;

/* preco de venda unico cada lanche */
CREATE VIEW pv_unico_itens
AS
SELECT distinct ipc.id_item, ipc.empresa, crp.item, preco_item, receita_p, custo_unitario, CAST(custo_unitario * receita_p AS DECIMAL(5,2)) cdv_u, CAST(preco_item * receita_p AS DECIMAL(5,2))  pv_unico FROM lista_itens_produtos_custo_unitario ipc
INNER JOIN custos_receita_p crp ON crp.id_item = ipc.id_item;

/* preco de venda unico total */
CREATE VIEW pv_unico_total
AS
SELECT empresa, SUM(pv_unico) OVER (PARTITION BY empresa) AS pv_unico_total, SUM(cdv_u) OVER (PARTITION BY empresa) AS cdv_u_total  FROM pv_unico_itens;

/* margem de contribuição unica do todo */
CREATE VIEW mc_unica
AS
SELECT empresa, pv_unico_total - cdv_u_total mc_unica FROM pv_unico_total;


/* ponto de equilibrio contábil */
/* unidades */
CREATE VIEW pec_u
AS
SELECT DISTINCT tf.empresa, total_fixos, total_salarios, mc_unica, CAST((IFNULL(total_fixos, 0) + IFNULL(total_salarios, 0)) / mc_unica AS DECIMAL(5,2)) AS PEC_U FROM total_fixos tf
INNER JOIN mc_unica mc ON mc.empresa = tf.empresa
LEFT JOIN total_salarios ts ON tf.empresa = ts.empresa;



CREATE VIEW pe
AS
SELECT total_vendas_itens_mes.empresa, total_vendas_itens_mes.id_item, item, receita_p, CAST(PEC_U * receita_p AS DECIMAL(5,2)) PE, vendas FROM total_vendas_itens_mes
INNER JOIN pv_unico_itens ON pv_unico_itens.id_item = total_vendas_itens_mes.id_item
INNER JOIN pec_u ON pec_u.empresa = total_vendas_itens_mes.empresa;

                    /* - MARGEM DE SEGURANÇA  */

CREATE VIEW margem_seguranca
AS
SELECT *, vendas - PE ms FROM pe;











CREATE VIEW itens_detalhes
AS
SELECT  li.empresa, 
        preco_unitario,
        peso_quantidade,
        id_produto, 
        id,
        produto, 
        custo_produto, 
        li.id_item, 
        li.nome item,
        li.descricao, 
        li.preco, 
        mcp.custo_unitario,
        M_C_U,
        M_C_T M_C_T_MES,
        M_C_U_P,
        custo_total custo_total_mes,
        receita receita_mes,
        ms.receita_p * 100 receita_mes_p,
        ms.vendas,
        ms.PE pe_mes,
        ms ms_mes
        FROM lista_itens li
LEFT JOIN lista_itens_produtos_custo_unitario_M_C_U_P mcp ON li.id_item = mcp.id_item
LEFT JOIN lista_itens_M_C_T mct ON mct.id_item = li.id_item
LEFT JOIN pe ON pe.id_item = li.id_item
LEFT JOIN margem_seguranca ms ON ms.id_item = li.id_item;