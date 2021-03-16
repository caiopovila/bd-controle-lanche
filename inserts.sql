INSERT INTO empresas (nome, email, senha, fone) VALUES 
('Casa do norte', 'casadonorte@hotmail.com', 'casadonorte1', '1234567');


INSERT INTO fornecedores (fornecedor, fone, empresa) VALUES 
('Casa da laranja', '123145', 1),
('açogue', '244245', 1),
('padaria', "232444454", 1),
('Fermentos legal', "24673454", 1);


INSERT INTO produtos (produto, preco_unitario, tipo, empresa) VALUES 
('alcatra', 36.00, 'pronto', 1),
('alface', 18.00, 'pronto', 1),
('bacon', 33.00, 'pronto', 1),
('barbecue', 4.70, 'pronto', 1),
('calabresa', 11.30, 'pronto', 1),
('catupiry', 13.50, 'pronto', 1),
('frango desfiado', 22.60, 'pronto', 1),
('geleia de pimenta', 2.50, 'pronto', 1),
('linguiça defumada', 30.00, 'pronto', 1),
('molho', 3.30, 'pronto', 1),
('mussarela', 21.00, 'pronto', 1),
('pao', 20.00, 'pronto', 1),
('povorone', 35.85, 'pronto', 1),
('pure de batata', 12.60, 'pronto', 1),
('salsicha', 10.50, 'pronto', 1),
('tomate', 5.40, 'pronto', 1);


INSERT INTO estoques (quantidade, peso_unitario, unidade_medida, fornecedor, empresa, produto) VALUES
(12, 1, 'kg', 1, 1, 1),
(20, 1, 'kg', 2, 1, 2),
(30, 1, 'kg', 3, 1, 3),
(10, 1, 'kg', 2, 1, 4),
(10, 1, 'kg', 1, 1, 5),
(30, 0.5, 'kg', 2, 1, 6),
(20, 1, 'kg', 3, 1, 7),
(5, 1, 'kg', 2, 1, 8),
(30, 0.5, 'kg', 2, 1, 9),
(10, 1, 'kg', 2, 1, 10),
(30, 0.5, 'kg', 2, 1, 11),
(20, 1, 'kg', 3, 1, 12),
(15, 0.5, 'kg', 1, 1, 13),
(20, 1, 'kg', 2, 1, 14),
(30, 2, 'kg', 3, 1, 15),
(30, 1, 'kg', 2, 1, 16);


INSERT INTO cardapios (nome, descricao, empresa) VALUES
('cardapio da noite', 'melhores escolhas para voce', 1),
('cardapio do dia', 'melhores escolhas para voce', 1);


INSERT INTO itens (nome, descricao, preco, empresa) VALUES
('item 1', 'feito para dieta', 11.00, 1),
('item 2', 'feito para encher', 12.50, 1),
('item 3', 'feito para matar a sede', 12.00, 1),
('item 4', 'feito para dieta', 13.00, 1),
('item 5', 'feito para encher', 13.00, 1),
('item 6', 'feito para matar a sede', 13.00, 1),
('item 7', 'feito para dieta', 10.00, 1),
('item 8', 'feito para encher', 9.00, 1),
('item 9', 'feito para matar a sede', 8.50, 1),
('item 10', 'feito para voce', 13.00, 1),
('item 11', 'feito para encher', 13.00, 1),
('item 12', 'feito para matar a sede', 12.00, 1);


INSERT INTO itens_cardapios (id_cardapio, id_item) VALUES
(1, 1),
(1, 2),
(1, 3),
(1, 4),
(1, 5);


INSERT INTO produtos_itens (id_produto, id_item, peso_quantidade, unidade_medida) VALUES
(1, 1, 0.1, 'kg'),
(2, 1, 0.02, 'kg'),
(3, 1, 0.003, 'kg'),
(6, 1, 0.004, 'kg'),
(11, 1, 0.015, 'kg'),
(12, 1, 0.1, 'kg'),
(16, 1, 0.05, 'kg'),
(1, 2, 0.1, 'kg'),
(2, 2, 0.1, 'kg'),
(6, 2, 0.001, 'kg'),
(11, 2, 0.015, 'kg'),
(12, 2, 0.1, 'kg'),
(16, 2, 0.01, 'kg'),
(1, 3, 0.1, 'kg'),
(2, 3, 0.01, 'kg'),
(4, 3, 0.1, 'kg'),
(11, 3, 0.015, 'kg'),
(12, 3, 0.1, 'kg'),
(16, 3, 0.01, 'kg'),
(4, 4, 0.01, 'kg'),
(11, 4, 0.015, 'kg'),
(12, 4, 0.1, 'kg'),
(16, 4, 0.01, 'kg'),
(4, 5, 0.01, 'kg'),
(11, 5, 0.03, 'kg'),
(12, 5, 0.1, 'kg'),
(16, 5, 0.01, 'kg'),
(4, 6, 0.01, 'kg'),
(11, 6, 0.03, 'kg'),
(12, 6, 0.1, 'kg'),
(16, 6, 0.01, 'kg');



INSERT INTO clientes (nome, fone, email, empresa) VALUES
('Caio', '2313534', 'caio@mail.com', 1),
('Icaro', '253747', 'icaro@mail.com', 1),
('Ele', '2313534', 'ele@mail.com', 1),
('Ela', '78778734', 'ela@mail.com', 1);



INSERT INTO enderecos (rua, numero, bairro, cidade, cep, empresa) VALUES
('rua tal', 12, 'tal', 'cit tal', "11233", 1),
('rua it', 26, 'talzvil', 'cit vil', "41245", 1),
('rua valho', 29, 'valhovil', 'cit valho', "32456", 1),
('avenida elementar', 2922, 'valhovil', 'cit valho', "421242", 1);




INSERT INTO enderecos_clientes (endereco, cliente) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4);


INSERT INTO fretes (bairro, cidade, preco, empresa) VALUES
('tal', 'cit tal', 5.00, 1),
('talzvil', 'cit vil', 6.00, 1),
('valhovil', 'cit valho', 5.00, 1);



INSERT INTO vendas (data_criado, endereco, frete, progresso, preco_total, cliente, empresa) VALUES
(now(), 3, 2.00, 'entregue', 0, 3, 1),
(now(), 1, 2.00, 'entregue', 0, 1, 1),
(now(), 3, 2.00, 'entregue', 0, 3, 1),
(now(), 1, 2.00, 'despachado', 0, 1, 1),
(now(), 2, 2.00, 'entregue', 0, 2, 1),
(now(), 2, 2.00, 'despachado', 0, 2, 1),
(now(), 2, 2.00, 'entregue', 0, 2, 1),
(now(), 1, 2.00, 'entregue', 0, 1, 1),
(now(), 2, 2.00, 'entregue', 0, 2, 1),
(now(), 1, 2.00, 'entregue', 0, 1, 1),
(now(), 2, 2.00, 'entregue', 0, 2, 1),
(now(), 1, 2.00, 'despachado', 0, 1, 1),
(now(), 3, 2.00, 'entregue', 0, 3, 1),
(now(), 1, 2.00, 'despachado', 0, 1, 1),
(now(), 2, 2.00, 'entregue', 0, 2, 1),
(now(), 2, 2.00, 'despachado', 0, 2, 1),
(now(), 2, 2.00, 'entregue', 0, 2, 1),
(now(), 1, 2.00, 'entregue', 0, 1, 1),
(now(), 2, 2.00, 'entregue', 0, 2, 1),
(now(), 1, 2.00, 'despachado', 0, 1, 1),
(now(), 2, 2.00, 'entregue', 0, 2, 1);


INSERT INTO itens_venda (venda, item, nome, preco) VALUES
(1, 1, 'item 1', 11.00),
(1, 2, 'item 2', 12.50),
(1, 3, 'item 3', 12.00),
(2, 4, 'item 4', 13.00),
(3, 7, 'item 7', 11.00),
(4, 2, 'item 2', 12.50),
(4, 5, 'item 5', 11.00),
(5, 4, 'item 4', 13.00),
(6, 7, 'item 7', 11.00),
(7, 2, 'item 2', 12.50),
(7, 3, 'item 3', 12.00),
(8, 9, 'item 9', 11.00),
(9, 9, 'item 9', 11.00),
(10, 1, 'item 1', 11.00),
(10, 3, 'item 3', 12.00),
(11, 7, 'item 7', 11.00),
(12, 7, 'item 7', 11.00),
(13, 10, 'item 10', 11.00),
(13, 3, 'item 3', 12.00),
(14, 4, 'item 4', 13.00),
(15, 7, 'item 7', 11.00);


INSERT INTO funcionarios (id_funcionario, nome, salario, dia_pagamento, funcao, data_cadastro, empresa) VALUES
(1, 'Func 1', 2000, 5, 'tecnico', now(), 1);

INSERT INTO custos_fixos (nome, valor, dia_vencimento, data_cadastro, empresa) VALUES
('ALUGUEL', 1000, '05', now(), 1),
('ENERGIA', 300, '05', now(), 1),
('LIMPEZA', 10, '05', now(), 1),
('DISPESAS BANCARIAS', 50, '05', now(), 1),
('TELEFONE/INTERNET', 150, '05', now(), 1),
('GAS DE COZINHA', 500, '05', now(), 1),
('EMBALAGENS', 200, '05', now(), 1),
('SISTEMA', 50, '05', now(), 1);
