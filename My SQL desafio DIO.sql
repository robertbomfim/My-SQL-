-- CRIAÇÃO DO BANCO DE DADOS
CREATE DATABASE ecommerce;
USE ecommerce;

-- TABELA CLIENTES
CREATE TABLE clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    telefone VARCHAR(20),
    data_cadastro DATE DEFAULT (CURRENT_DATE)
);

-- TABELA ENDERECOS
CREATE TABLE enderecos (
    id_endereco INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT,
    rua VARCHAR(150),
    numero VARCHAR(10),
    cidade VARCHAR(100),
    estado VARCHAR(50),
    cep VARCHAR(10),
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

-- TABELA PRODUTOS
CREATE TABLE produtos (
    id_produto INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    preco DECIMAL(10,2) NOT NULL,
    estoque INT DEFAULT 0
);

-- TABELA PEDIDOS
CREATE TABLE pedidos (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT,
    data_pedido DATETIME DEFAULT CURRENT_TIMESTAMP,
    status ENUM('PENDENTE', 'PAGO', 'ENVIADO', 'ENTREGUE', 'CANCELADO') DEFAULT 'PENDENTE',
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

-- TABELA ITENS DO PEDIDO
CREATE TABLE itens_pedido (
    id_item INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT,
    id_produto INT,
    quantidade INT DEFAULT 1,
    preco_unitario DECIMAL(10,2),
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido),
    FOREIGN KEY (id_produto) REFERENCES produtos(id_produto)
);

-- TABELA PAGAMENTOS
CREATE TABLE pagamentos (
    id_pagamento INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT,
    valor DECIMAL(10,2),
    forma_pagamento ENUM('CARTAO', 'PIX', 'BOLETO'),
    status ENUM('PENDENTE', 'CONFIRMADO', 'CANCELADO') DEFAULT 'PENDENTE',
    data_pagamento DATETIME,
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido)
);
show table status


-- 1 CLIENTES
INSERT INTO clientes (nome, email, telefone)
VALUES
('Maria Silva', 'maria.silva@email.com', '(11)98888-1111'),
('João Souza', 'joao.souza@email.com', '(21)97777-2222'),
('Ana Costa', 'ana.costa@email.com', '(31)96666-3333'),
('Carlos Pereira', 'carlos.pereira@email.com', '(41)95555-4444'),
('Beatriz Lima', 'beatriz.lima@email.com', '(51)94444-5555');

-- 2️ ENDEREÇOS
INSERT INTO enderecos (id_cliente, rua, numero, cidade, estado, cep)
VALUES
(1, 'Rua das Flores', '123', 'São Paulo', 'SP', '01001-000'),
(1, 'Av. Brasil', '500', 'Guarulhos', 'SP', '07112-000'),
(2, 'Rua das Acácias', '45', 'Rio de Janeiro', 'RJ', '22000-000'),
(3, 'Rua Minas Gerais', '78', 'Belo Horizonte', 'MG', '30110-000'),
(4, 'Av. Paraná', '1500', 'Curitiba', 'PR', '80000-000'),
(5, 'Rua Porto Alegre', '300', 'Porto Alegre', 'RS', '90000-000');

-- 3️ PRODUTOS
INSERT INTO produtos (nome, descricao, preco, estoque)
VALUES
('Notebook Lenovo', 'Notebook Lenovo IdeaPad 15.6"', 3500.00, 10),
('Mouse Logitech', 'Mouse sem fio Logitech M170', 80.00, 50),
('Teclado Mecânico Redragon', 'Teclado gamer RGB ABNT2', 250.00, 20),
('Monitor LG', 'Monitor 24" Full HD', 900.00, 15),
('Cadeira Gamer', 'Cadeira ergonômica preta/vermelha', 1200.00, 8);

-- 4️ PEDIDOS
INSERT INTO pedidos (id_cliente, data_pedido, status)
VALUES
(1, '2025-10-01 10:30:00', 'PAGO'),
(2, '2025-10-03 15:45:00', 'ENVIADO'),
(3, '2025-10-05 09:00:00', 'PENDENTE'),
(4, '2025-10-06 13:20:00', 'ENTREGUE'),
(5, '2025-10-07 18:00:00', 'CANCELADO');

-- 5️ ITENS DE PEDIDO
INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_unitario)
VALUES
(1, 1, 1, 3500.00), -- Maria comprou um notebook
(1, 2, 2, 80.00), -- Maria também comprou dois mouses
(2, 3, 1, 250.00), -- João comprou um teclado
(2, 4, 1, 900.00), -- João comprou um monitor
(3, 2, 1, 80.00), -- Ana comprou um mouse
(3, 5, 1, 1200.00), -- Ana comprou uma cadeira gamer
(4, 1, 1, 3500.00), -- Carlos comprou um notebook
(5, 3, 1, 250.00); -- Beatriz comprou um teclado (pedido cancelado)

-- 6️ PAGAMENTOS
INSERT INTO pagamentos (id_pedido, valor, forma_pagamento, status, data_pagamento)
VALUES
(1, 3660.00, 'CARTAO', 'CONFIRMADO', '2025-10-01 11:00:00'),
(2, 1150.00, 'PIX', 'CONFIRMADO', '2025-10-03 16:00:00'),
(3, 1280.00, 'BOLETO', 'PENDENTE', NULL),
(4, 3500.00, 'CARTAO', 'CONFIRMADO', '2025-10-06 14:00:00'),
(5, 250.00, 'PIX', 'CANCELADO', '2025-10-07 19:00:00');


-- Ver todos os pedidos com nome do cliente
SELECT p.id_pedido, c.nome AS cliente, p.data_pedido, p.status
FROM pedidos p
JOIN clientes c ON p.id_cliente = c.id_cliente;

-- Ver os itens de cada pedido
SELECT i.id_pedido, pr.nome AS produto, i.quantidade, i.preco_unitario
FROM itens_pedido i
JOIN produtos pr ON i.id_produto = pr.id_produto;

-- Ver pedidos e pagamentos
SELECT p.id_pedido, c.nome, pg.forma_pagamento, pg.status, pg.valor
FROM pagamentos pg
JOIN pedidos p ON pg.id_pedido = p.id_pedido
JOIN clientes c ON p.id_cliente = c.id_cliente;

-- Total de vendas confirmadas
SELECT SUM(valor) AS total_vendas
FROM pagamentos
WHERE status = 'CONFIRMADO';


