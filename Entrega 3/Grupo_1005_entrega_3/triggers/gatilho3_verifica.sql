.mode columns
.header on
.nullvalue NULL

PRAGMA foreign_keys = ON;

--TESTE DO GATILHO adicionaCaixaEncomenda, updateCaixaEncomenda, deleteCaixaEncomenda

--Valor atual da encomenda 12 (3)
SELECT Encomenda.valor FROM Encomenda WHERE Encomenda.idEncomenda = 12;

--Inserir uma caixa e associa-la à encomenda 12
INSERT INTO Caixa VALUES(30, 12, 3, 5);

--Valor da encomenda  (3 + 15)
SELECT Encomenda.valor FROM Encomenda WHERE Encomenda.idEncomenda = 12;

--Dar update à caixa 30, caixa da encomenda 12 que acabamos de adicionar
UPDATE caixa SET volume = 3, peso = 2 WHERE idCaixa = 30;

--Valor da encomenda 12 (3 + 6)
SELECT Encomenda.valor FROM Encomenda WHERE Encomenda.idEncomenda = 12;

--Dar update à caixa 30, caixa da encomenda 12 que acabamos de adicionar
DELETE FROM Caixa WHERE idCaixa = 30;

--Valor da encomenda 12 (3)
SELECT Encomenda.valor FROM Encomenda WHERE Encomenda.idEncomenda = 12;


--TESTE DO GATILHO deleteEncomendaDeleteCliente, deleteCaixadeleteEncomenda

--Encomendas do Cliente com id = 2
SELECT Encomenda.idEncomenda FROM Encomenda
WHERE Encomenda.idCliente = 2;

--Apagar 3 das encomendas do cliente
Delete from Encomenda where idEncomenda = 4;
Delete from Encomenda where idEncomenda = 13;
Delete from Encomenda where idEncomenda = 20;

--A caixa 4 é a única caixa da encomenda 2
SELECT Caixa.idCaixa FROM Caixa
WHERE Caixa.idEncomenda = 2;

--Caixa é apagada
Delete from Caixa where idCaixa = 4;

--A encomenda foi apagada também
SELECT * FROM Encomenda WHERE Encomenda.idEncomenda = 2;

--Como não tem nenhuma encomenda antiga o ativa, o cliente é apagado
SELECT * FROM Cliente WHERE Cliente.idCliente = 2;