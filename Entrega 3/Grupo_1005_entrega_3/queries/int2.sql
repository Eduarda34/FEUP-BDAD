.mode columns
.headers on
.nullvalue NULL

--Quais os clientes que gastaram mais em encomendas? - 2
SELECT Pessoa.nome, SUM(Encomenda.valor) AS TotalEncomendas
FROM Encomenda LEFT JOIN Pessoa ON Encomenda.idCliente = Pessoa.idPessoa 
GROUP BY Encomenda.idCliente
ORDER BY TotalEncomendas DESC;