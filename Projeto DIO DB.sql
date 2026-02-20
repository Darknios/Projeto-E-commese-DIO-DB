-- =====================================================
-- Criação do banco de dados para E-commerce (refinado)
-- =====================================================
DROP DATABASE IF EXISTS ecommerce;
CREATE DATABASE ecommerce;
USE ecommerce;

-- -----------------------------------------------------
-- Tabela cliente (agora com suporte a PF e PJ)
-- -----------------------------------------------------
CREATE TABLE client (
    idClient INT AUTO_INCREMENT PRIMARY KEY,
    Fname VARCHAR(10) NOT NULL,
    Minit CHAR(3),
    Lname VARCHAR(20) NOT NULL,
    type ENUM('PF', 'PJ') NOT NULL DEFAULT 'PF',
    CPF CHAR(11) NULL,
    CNPJ CHAR(14) NULL,
    Address VARCHAR(100),
    CONSTRAINT unique_cpf_client UNIQUE (CPF),
    CONSTRAINT unique_cnpj_client UNIQUE (CNPJ),
    CONSTRAINT check_pf_pj CHECK (
        (type = 'PF' AND CPF IS NOT NULL AND CNPJ IS NULL) OR
        (type = 'PJ' AND CNPJ IS NOT NULL AND CPF IS NULL)
    )
);

-- Inserindo clientes PF (existentes) e um novo PJ
INSERT INTO client (Fname, Minit, Lname, type, CPF, Address) VALUES
    ('Maria','M','Silva','PF','12346789','rua silva de prata 29, Carangola - Cidade das flores'),
    ('Matheus','O','Pimentel','PF','987654321','rua alemeda 289, Centro - Cidade das flores'),
    ('Ricardo','F','Silva','PF','45678913','avenida almeda vinha 1009, Centro - Cidade das flores'),
    ('Julia','S','França','PF','789123456','rua laranjeiras 861, Centro - Cidade das flores'),
    ('Roberta','G','Assis','PF','98745631','avenidade koller 19, Centro - Cidade das flores'),
    ('Isabela','M','Cruz','PF','654789123','rua alemeda das flores 28, Centro - Cidade das flores');

INSERT INTO client (Fname, Minit, Lname, type, CNPJ, Address) VALUES
    ('Empresa','X','Ltda','PJ','12345678000199','Av. Comercial 1000, Centro');

-- -----------------------------------------------------
-- Tabela produto
-- -----------------------------------------------------
CREATE TABLE product (
    idProduct INT AUTO_INCREMENT PRIMARY KEY,
    Pname VARCHAR(100) NOT NULL,
    classification_kids BOOL,
    category ENUM('Eletrônico','Vestimenta','Brinquedos','Alimentos','Móveis') NOT NULL,
    avaliação FLOAT DEFAULT 0,
    size VARCHAR(10)
);

INSERT INTO product (Pname, classification_kids, category, avaliação, size) VALUES
    ('Fone de ouvido', false, 'Eletrônico', 4, null),
    ('Barbie Elsa', true, 'Brinquedos', 3, null),
    ('Body Carters', true, 'Vestimenta', 5, null),
    ('Microfone Youtuber', false, 'Eletrônico', 4, null),
    ('Sofá retrátil', false, 'Móveis', 3, '3x57x80'),
    ('Farinha de arroz', false, 'Alimentos', 2, null),
    ('Fire Stick Amazon', false, 'Eletrônico', 3, null);

-- -----------------------------------------------------
-- Tabela pagamentos (já permite múltiplos por cliente)
-- -----------------------------------------------------
CREATE TABLE payments (
    idClient INT,
    idPayment INT,
    typePayment ENUM('Boleto','Cartão','Dois cartões'),
    limitAvaliable FLOAT,
    PRIMARY KEY (idClient, idPayment),
    FOREIGN KEY (idClient) REFERENCES client(idClient)
);

INSERT INTO payments (idClient, idPayment, typePayment, limitAvaliable) VALUES
    (1, 1, 'Cartão', 1000.00),
    (1, 2, 'Boleto', NULL),
    (2, 1, 'Cartão', 500.00);

-- -----------------------------------------------------
-- Tabela pedido
-- -----------------------------------------------------
CREATE TABLE orders (
    idOrder INT AUTO_INCREMENT PRIMARY KEY,
    idOrderClient INT,
    orderStatus ENUM('Cancelado','Confirmado','Em processamento') DEFAULT 'Em processamento',
    orderDescription VARCHAR(255),
    sendValue FLOAT DEFAULT 10,
    paymentCash BOOLEAN DEFAULT false,
    CONSTRAINT fk_orders_client FOREIGN KEY (idOrderClient) REFERENCES client(idClient) ON UPDATE CASCADE
);

INSERT INTO orders (idOrderClient, orderStatus, orderDescription, sendValue, paymentCash) VALUES
    (1, DEFAULT, 'compra via aplicativo', NULL, 1),
    (2, DEFAULT, 'compra via aplicativo', 50, 0),
    (3, 'Confirmado', NULL, NULL, 1),
    (4, DEFAULT, 'compra via web site', 150, 0),
    (2, DEFAULT, 'compra via aplicativo', NULL, 1);  -- mais um pedido para o cliente 2

-- -----------------------------------------------------
-- Tabela entrega (novo requisito)
-- -----------------------------------------------------
CREATE TABLE delivery (
    idDelivery INT AUTO_INCREMENT PRIMARY KEY,
    idOrder INT NOT NULL,
    status ENUM('Aguardando envio','Enviado','Em trânsito','Entregue') DEFAULT 'Aguardando envio',
    trackingCode VARCHAR(20),
    estimatedDate DATE,
    deliveredDate DATE,
    CONSTRAINT fk_delivery_order FOREIGN KEY (idOrder) REFERENCES orders(idOrder) ON DELETE CASCADE
);

-- Inserindo entregas para os pedidos existentes
INSERT INTO delivery (idOrder, status, trackingCode, estimatedDate, deliveredDate) VALUES
    (1, 'Entregue', 'BR123456789BR', '2025-01-10', '2025-01-09'),
    (2, 'Em trânsito', 'BR987654321BR', '2025-02-20', NULL),
    (3, 'Aguardando envio', NULL, NULL, NULL),
    (4, 'Enviado', 'BR555555555BR', '2025-02-25', NULL),
    (5, 'Aguardando envio', NULL, NULL, NULL);

-- -----------------------------------------------------
-- Tabela estoque
-- -----------------------------------------------------
CREATE TABLE productStorage (
    idProdStorage INT AUTO_INCREMENT PRIMARY KEY,
    storageLocation VARCHAR(255),
    quantity INT DEFAULT 0
);

INSERT INTO productStorage (storageLocation, quantity) VALUES
    ('Rio de Janeiro', 1000),
    ('Rio de Janeiro', 500),
    ('São Paulo', 10),
    ('São Paulo', 100),
    ('São Paulo', 10),
    ('Brasília', 60);

-- -----------------------------------------------------
-- Tabela fornecedor
-- -----------------------------------------------------
CREATE TABLE supplier (
    idSupplier INT AUTO_INCREMENT PRIMARY KEY,
    SocialName VARCHAR(255) NOT NULL,
    CNPJ CHAR(15) NOT NULL,
    contact CHAR(11) NOT NULL,
    CONSTRAINT unique_supplier UNIQUE (CNPJ)
);

INSERT INTO supplier (SocialName, CNPJ, contact) VALUES
    ('Almeida e filhos', '123456789123456', '21985474'),
    ('Eletrônicos Silva', '854519649143457', '21985484'),
    ('Eletrônicos Valma', '934567893934695', '21975474');

-- -----------------------------------------------------
-- Tabela vendedor
-- -----------------------------------------------------
CREATE TABLE seller (
    idSeller INT AUTO_INCREMENT PRIMARY KEY,
    SocialName VARCHAR(255) NOT NULL,
    AbstName VARCHAR(255),
    CNPJ CHAR(15),
    CPF CHAR(9),
    location VARCHAR(255),
    contact CHAR(11) NOT NULL,
    CONSTRAINT unique_cnpj_seller UNIQUE (CNPJ),
    CONSTRAINT unique_cpf_seller UNIQUE (CPF)
);

INSERT INTO seller (SocialName, CNPJ, contact) VALUES
    ('Vendedor Exemplo', '123456789012345', '1199999999'),
    ('Tech Shop', '987654321098765', '1188888888');

-- -----------------------------------------------------
-- Tabela produto_vendedor (relaciona produto a vendedor)
-- -----------------------------------------------------
CREATE TABLE productSeller (
    idPseller INT,
    idPproduct INT,
    prodQuantity INT DEFAULT 1,
    PRIMARY KEY (idPseller, idPproduct),
    CONSTRAINT fk_product_seller FOREIGN KEY (idPseller) REFERENCES seller(idSeller),
    CONSTRAINT fk_product_product FOREIGN KEY (idPproduct) REFERENCES product(idProduct)
);

INSERT INTO productSeller (idPseller, idPproduct, prodQuantity) VALUES
    (1, 1, 500),
    (1, 2, 400),
    (2, 6, 80),
    (2, 7, 10);

-- -----------------------------------------------------
-- Tabela produto_pedido
-- -----------------------------------------------------
CREATE TABLE productOrder (
    idPOproduct INT,
    idPOrder INT,
    poQuantity INT DEFAULT 1,
    poStatus ENUM('Disponível', 'Sem estoque') DEFAULT 'Disponível',
    PRIMARY KEY (idPOproduct, idPOrder),
    CONSTRAINT fk_productorder_product FOREIGN KEY (idPOproduct) REFERENCES product(idProduct),
    CONSTRAINT fk_productorder_order FOREIGN KEY (idPOrder) REFERENCES orders(idOrder)
);

INSERT INTO productOrder (idPOproduct, idPOrder, poQuantity, poStatus) VALUES
    (1, 1, 2, DEFAULT),
    (2, 1, 1, DEFAULT),
    (3, 2, 1, DEFAULT),
    (4, 3, 1, DEFAULT),
    (5, 4, 1, DEFAULT),
    (6, 5, 3, DEFAULT),
    (7, 5, 1, DEFAULT);

-- -----------------------------------------------------
-- Tabela produto_fornecedor
-- -----------------------------------------------------
CREATE TABLE productSupplier (
    idPsSupplier INT,
    idPsProduct INT,
    quantity INT NOT NULL,
    PRIMARY KEY (idPsSupplier, idPsProduct),
    CONSTRAINT fk_prodsupplier_supplier FOREIGN KEY (idPsSupplier) REFERENCES supplier(idSupplier),
    CONSTRAINT fk_prodsupplier_product FOREIGN KEY (idPsProduct) REFERENCES product(idProduct)
);

INSERT INTO productSupplier (idPsSupplier, idPsProduct, quantity) VALUES
    (1, 1, 500),
    (1, 2, 400),
    (2, 4, 300),
    (3, 7, 200);

-- -----------------------------------------------------
-- Tabela localização_estoque (relaciona produto a local de estoque)
-- -----------------------------------------------------
CREATE TABLE storageLocation (
    idLproduct INT,
    idLstorage INT,
    location VARCHAR(255) NOT NULL,
    PRIMARY KEY (idLproduct, idLstorage),
    CONSTRAINT fk_storage_location_product FOREIGN KEY (idLproduct) REFERENCES product(idProduct),
    CONSTRAINT fk_storage_location_storage FOREIGN KEY (idLstorage) REFERENCES productStorage(idProdStorage)
);

INSERT INTO storageLocation (idLproduct, idLstorage, location) VALUES
    (1, 1, 'Prateleira A'),
    (2, 1, 'Prateleira B'),
    (3, 2, 'Gaveta 3'),
    (4, 3, 'Estante 5'),
    (5, 4, 'Pallet 2'),
    (6, 5, 'Setor de Alimentos'),
    (7, 6, 'Setor Eletrônicos');

-- =====================================================
-- QUERIES COMPLEXAS (atendendo aos requisitos)
-- =====================================================

-- 1. Recuperações simples com SELECT Statement
SELECT * FROM client;
SELECT * FROM product WHERE category = 'Eletrônico';

-- 2. Filtros com WHERE Statement
SELECT idOrder, orderStatus, sendValue 
FROM orders 
WHERE sendValue > 0 AND paymentCash = 0;

-- 3. Atributos derivados (ex: valor total do pedido considerando quantidade e frete)
SELECT 
    o.idOrder,
    c.Fname AS Cliente,
    SUM(p.avaliação * po.poQuantity) AS PontuacaoTotal, -- só exemplo
    o.sendValue AS Frete,
    (o.sendValue + 10) AS ValorComTaxa -- atributo derivado
FROM orders o
INNER JOIN client c ON o.idOrderClient = c.idClient
INNER JOIN productOrder po ON o.idOrder = po.idPOrder
INNER JOIN product p ON po.idPOproduct = p.idProduct
GROUP BY o.idOrder;

-- 4. Ordenação com ORDER BY
SELECT Pname, avaliação FROM product ORDER BY avaliação DESC;

-- 5. Condições de filtros aos grupos – HAVING Statement
-- Clientes com mais de 1 pedido
SELECT 
    c.idClient,
    CONCAT(c.Fname, ' ', c.Lname) AS Nome,
    COUNT(*) AS NumPedidos
FROM client c
INNER JOIN orders o ON c.idClient = o.idOrderClient
GROUP BY c.idClient
HAVING COUNT(*) > 1;

-- 6. Junções entre tabelas para perspectiva complexa
-- a) Quantos pedidos foram feitos por cada cliente? (já incluso no HAVING, mas aqui com detalhes)
SELECT 
    c.idClient,
    c.Fname,
    c.Lname,
    COUNT(o.idOrder) AS TotalPedidos,
    IFNULL(SUM(o.sendValue), 0) AS TotalFrete
FROM client c
LEFT JOIN orders o ON c.idClient = o.idOrderClient
GROUP BY c.idClient;

-- b) Algum vendedor também é fornecedor? (comparando CNPJ)
SELECT 
    s.idSeller,
    s.SocialName AS Vendedor,
    sup.idSupplier,
    sup.SocialName AS Fornecedor
FROM seller s
INNER JOIN supplier sup ON s.CNPJ = sup.CNPJ;

-- c) Relação de produtos, fornecedores e estoques
SELECT 
    p.Pname AS Produto,
    s.SocialName AS Fornecedor,
    ps.quantity AS QuantidadeFornecida,
    sl.location AS LocalEstoque,
    pst.quantity AS EstoqueDisponivel
FROM product p
INNER JOIN productSupplier ps ON p.idProduct = ps.idPsProduct
INNER JOIN supplier s ON ps.idPsSupplier = s.idSupplier
INNER JOIN storageLocation sl ON p.idProduct = sl.idLproduct
INNER JOIN productStorage pst ON sl.idLstorage = pst.idProdStorage;

-- d) Relação de nomes dos fornecedores e nomes dos produtos
SELECT 
    sup.SocialName AS Fornecedor,
    p.Pname AS Produto,
    ps.quantity AS Quantidade
FROM supplier sup
INNER JOIN productSupplier ps ON sup.idSupplier = ps.idPsSupplier
INNER JOIN product p ON ps.idPsProduct = p.idProduct
ORDER BY Fornecedor;

-- e) Pedidos com status da entrega e código de rastreio
SELECT 
    o.idOrder,
    c.Fname AS Cliente,
    o.orderStatus AS StatusPedido,
    d.status AS StatusEntrega,
    d.trackingCode AS CodigoRastreio,
    d.estimatedDate AS Previsao,
    d.deliveredDate AS DataEntrega
FROM orders o
INNER JOIN client c ON o.idOrderClient = c.idClient
LEFT JOIN delivery d ON o.idOrder = d.idOrder;

-- f) Produtos mais bem avaliados (média > 4) e seus estoques
SELECT 
    p.Pname,
    p.avaliação,
    SUM(pst.quantity) AS EstoqueTotal
FROM product p
INNER JOIN storageLocation sl ON p.idProduct = sl.idLproduct
INNER JOIN productStorage pst ON sl.idLstorage = pst.idProdStorage
GROUP BY p.idProduct
HAVING AVG(p.avaliação) > 4
ORDER BY p.avaliação DESC;

-- g) Clientes que fizeram pedidos com valor de frete superior a 50
SELECT DISTINCT
    c.idClient,
    CONCAT(c.Fname, ' ', c.Lname) AS Nome,
    c.type AS Tipo
FROM client c
INNER JOIN orders o ON c.idClient = o.idOrderClient
WHERE o.sendValue > 50;