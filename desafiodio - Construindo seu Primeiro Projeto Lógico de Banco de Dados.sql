create database  desafiodio;

use desafiodio;

CREATE TABLE Clientes (
    cliente_id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefone VARCHAR(15),
    endereco VARCHAR(255)
);

CREATE TABLE Produtos (
    produto_id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    preco DECIMAL(10, 2) NOT NULL,
    estoque INT NOT NULL
);

CREATE TABLE Pedidos (
    pedido_id INT PRIMARY KEY AUTO_INCREMENT,
    cliente_id INT,
    data_pedido DATETIME DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(50),
    FOREIGN KEY (cliente_id) REFERENCES Clientes(cliente_id)
);

CREATE TABLE Itens_Pedido (
    item_id INT PRIMARY KEY AUTO_INCREMENT,
    pedido_id INT,
    produto_id INT,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (pedido_id) REFERENCES Pedidos(pedido_id),
    FOREIGN KEY (produto_id) REFERENCES Produtos(produto_id)
);

INSERT INTO Clientes (nome, email, telefone, endereco) VALUES
('João Silva', 'joao@example.com', '123456789', 'Rua A, 123'),
('Maria Oliveira', 'maria@example.com', '987654321', 'Rua B, 456');

INSERT INTO Produtos (nome, descricao, preco, estoque) VALUES
('Produto A', 'Descrição do Produto A', 100.00, 10),
('Produto B', 'Descrição do Produto B', 200.00, 5);

INSERT INTO Pedidos (cliente_id, status) VALUES
(1, 'Em andamento'),
(2, 'Concluído');

INSERT INTO Itens_Pedido (pedido_id, produto_id, quantidade, preco_unitario) VALUES
(1, 1, 2, 100.00),
(1, 2, 1, 200.00),
(2, 1, 1, 100.00);

SELECT * FROM Clientes;
SELECT * FROM Produtos WHERE preco > 150.00;
SELECT nome, preco, estoque, (preco * estoque) AS valor_total_estoque FROM Produtos;

SELECT pedido_id, SUM(quantidade) AS total_itens
FROM Itens_Pedido
GROUP BY pedido_id
HAVING total_itens > 2;

SELECT c.nome AS cliente_nome, p.data_pedido, SUM(ip.quantidade * ip.preco_unitario) AS total_pedido
FROM Clientes c
JOIN Pedidos p ON c.cliente_id = p.cliente_id
JOIN Itens_Pedido ip ON p.pedido_id = ip.pedido_id
GROUP BY c.nome, p.data_pedido
ORDER BY total_pedido DESC;