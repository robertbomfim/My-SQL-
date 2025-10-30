SELECT * FROM clientes;


SELECT nome, preco
FROM produtos
WHERE preco > 500
ORDER BY preco DESC;

SELECT id_pedido, id_cliente, status, data_pedido
FROM pedidos
WHERE status IN ('PAGO', 'ENVIADO')
ORDER BY data_pedido DESC;

SELECT c.nome AS cliente, pg.forma_pagamento, pg.status
FROM pagamentos pg
JOIN pedidos p ON pg.id_pedido = p.id_pedido
JOIN clientes c ON p.id_cliente = c.id_cliente
ORDER BY c.nome;

SELECT SUM(valor) AS total_vendas_confirmadas
FROM pagamentos
WHERE status = 'CONFIRMADO';

SELECT status, COUNT(*) AS total_pedidos
FROM pedidos
GROUP BY status
ORDER BY total_pedidos DESC;

SELECT c.nome AS cliente, SUM(pg.valor) AS total_gasto
FROM pagamentos pg
JOIN pedidos p ON pg.id_pedido = p.id_pedido
JOIN clientes c ON p.id_cliente = c.id_cliente
WHERE pg.status = 'CONFIRMADO'
GROUP BY c.nome
HAVING total_gasto > 0
ORDER BY total_gasto DESC;

SELECT pr.nome AS produto, SUM(i.quantidade) AS total_vendido
FROM itens_pedido i
JOIN produtos pr ON i.id_produto = pr.id_produto
GROUP BY pr.nome
ORDER BY total_vendido DESC;

SELECT p.id_pedido, c.nome AS cliente, SUM(i.quantidade * i.preco_unitario) AS valor_total
FROM pedidos p
JOIN itens_pedido i ON p.id_pedido = i.id_pedido
JOIN clientes c ON p.id_cliente = c.id_cliente
GROUP BY p.id_pedido, c.nome;

SELECT DISTINCT c.nome AS cliente
FROM clientes c
JOIN pedidos p ON c.id_cliente = p.id_cliente
JOIN pagamentos pg ON p.id_pedido = pg.id_pedido
WHERE pg.status = 'PENDENTE';
