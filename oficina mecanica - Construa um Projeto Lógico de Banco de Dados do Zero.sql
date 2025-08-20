

-- Tabela Cliente
CREATE TABLE IF NOT EXISTS Cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    endereco VARCHAR(200),
    telefone VARCHAR(20) NOT NULL,
    email VARCHAR(100)
);

-- Tabela Veiculo
CREATE TABLE IF NOT EXISTS Veiculo (
    id_veiculo INT AUTO_INCREMENT PRIMARY KEY,
    modelo VARCHAR(50) NOT NULL,
    marca VARCHAR(50) NOT NULL,
    ano INT,
    placa VARCHAR(10) UNIQUE NOT NULL,
    id_cliente INT NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente)
);

-- Tabela Mecanico
CREATE TABLE IF NOT EXISTS Mecanico (
    id_mecanico INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    endereco VARCHAR(200),
    especialidade VARCHAR(100) NOT NULL,
    telefone VARCHAR(20)
);

-- Tabela OrdemServico
CREATE TABLE IF NOT EXISTS OrdemServico (
    id_os INT AUTO_INCREMENT PRIMARY KEY,
    data_emissao DATE NOT NULL,
    valor_total DECIMAL(10, 2),
    status ENUM('Pendente', 'Em Andamento', 'Concluída', 'Cancelada') DEFAULT 'Pendente',
    data_conclusao DATE,
    id_veiculo INT NOT NULL,
    FOREIGN KEY (id_veiculo) REFERENCES Veiculo(id_veiculo)
);

-- Tabela de relacionamento entre OS e Mecânico (N:M)
CREATE TABLE IF NOT EXISTS OSMecanico (
    id_os_mecanico INT AUTO_INCREMENT PRIMARY KEY,
    id_os INT NOT NULL,
    id_mecanico INT NOT NULL,
    FOREIGN KEY (id_os) REFERENCES OrdemServico(id_os),
    FOREIGN KEY (id_mecanico) REFERENCES Mecanico(id_mecanico),
    UNIQUE KEY (id_os, id_mecanico)
);

-- Tabela Servico
CREATE TABLE IF NOT EXISTS Servico (
    id_servico INT AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(200) NOT NULL,
    valor_mao_obra DECIMAL(10, 2) NOT NULL,
    id_os INT NOT NULL,
    FOREIGN KEY (id_os) REFERENCES OrdemServico(id_os)
);

-- Tabela Peca
CREATE TABLE IF NOT EXISTS Peca (
    id_peca INT AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(100) NOT NULL,
    valor DECIMAL(10, 2) NOT NULL,
    quantidade INT DEFAULT 1,
    id_os INT NOT NULL,
    FOREIGN KEY (id_os) REFERENCES OrdemServico(id_os)
);


-- Inserindo dados na tabela Cliente
INSERT INTO Cliente (nome, endereco, telefone, email) VALUES
('João Silva', 'Rua A, 123', '1234-5678', 'joao@example.com'),
('Maria Oliveira', 'Rua B, 456', '9876-5432', 'maria@example.com');

-- Inserindo dados na tabela Veiculo
INSERT INTO Veiculo (modelo, marca, ano, placa, id_cliente) VALUES
('Fusca', 'Volkswagen', 1975, 'ABC-1234', 1),
('Civic', 'Honda', 2020, 'XYZ-5678', 2);

-- Inserindo dados na tabela Mecanico
INSERT INTO Mecanico (nome, endereco, especialidade, telefone) VALUES
('Carlos Mendes', 'Rua C, 789', 'Motor', '1111-2222'),
('Ana Costa', 'Rua D, 321', 'Suspensão', '3333-4444');

-- Inserindo dados na tabela OrdemServico
INSERT INTO OrdemServico (data_emissao, valor_total, status, id_veiculo) VALUES
('2023-10-01', 500.00, 'Pendente', 1),
('2023-10-02', 300.00, 'Em Andamento', 2);

-- Inserindo dados na tabela OSMecanico
INSERT INTO OSMecanico (id_os, id_mecanico) VALUES
(1, 1),
(2, 2);

-- Inserindo dados na tabela Servico
INSERT INTO Servico (descricao, valor_mao_obra, id_os) VALUES
('Troca de óleo', 100.00, 1),
('Alinhamento', 50.00, 2);

-- Inserindo dados na tabela Peca
INSERT INTO Peca (descricao, valor, quantidade, id_os) VALUES
('Óleo', 30.00, 2, 1),
('Pneu', 150.00, 4, 2);

SELECT * FROM Cliente;
SELECT * FROM Veiculo WHERE ano > 2015;
SELECT id_os, valor_total, valor_total * 0.1 AS imposto FROM OrdemServico;
SELECT * FROM Mecanico ORDER BY nome ASC;
SELECT id_os, COUNT(*) AS total_servicos
FROM Servico
GROUP BY id_os
HAVING total_servicos > 1;
SELECT o.id_os, c.nome AS cliente, v.modelo AS veiculo, o.valor_total
FROM OrdemServico o
JOIN Veiculo v ON o.id_veiculo = v.id_veiculo
JOIN Cliente c ON v.id_cliente = c.id_cliente
WHERE o.status = 'Pendente';