.mode columns
.headers on
.nullvalue NULL

--Quais os carros que transportam mais caixas ao longo do tempo? - 4
SELECT b.idCarro, b.matricula, SUM(a.numCaixas) AS totalNumCaixas
FROM (SELECT Caixa.idEncomenda, COUNT(*) AS numCaixas FROM Caixa
GROUP BY Caixa.idEncomenda) a,
(SELECT Viagem.idCarro, Carro.matricula, Encomenda.idEncomenda
FROM Viagem join Carro on Viagem.idCarro = Carro.idCarro, Encomenda
WHERE Encomenda.idViagem = Viagem.idViagem
ORDER BY Viagem.idCarro)b
WHERE a.idEncomenda = b.idEncomenda
GROUP BY b.idCarro
ORDER BY totalNumCaixas DESC;