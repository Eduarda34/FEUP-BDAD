.mode columns
.headers on
.nullvalue NULL

--Qual a média do número de encomendas por cliente?
SELECT ROUND(AVG(p.enc),2) as media_encomendas_por_cliente FROM
    (SELECT Pessoa.nome, COUNT(*) AS enc FROM Pessoa, Encomenda
    WHERE Pessoa.idPessoa = Encomenda.idCliente
    GROUP BY Pessoa.idPessoa) p
;