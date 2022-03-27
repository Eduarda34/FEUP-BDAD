.mode columns
.headers on
.nullvalue NULL

--Quais os nomes das pessoas que já fizeram pelo menos uma encomenda para os posto de entrega com o código postal '7340-002' e para '8000-316' - 6
SELECT Pessoa.nome
FROM Pessoa
WHERE Pessoa.idPessoa in
    (SELECT distinct Encomenda.idCliente
    FROM Encomenda, PostoEntrega
    WHERE PostoEntrega.codigoPostal LIKE '7340-002' AND Encomenda.idPostoEntrega = PostoEntrega.idPostoEntrega
    INTERSECT
    SELECT distinct Encomenda.idCliente
    FROM Encomenda, PostoEntrega
    WHERE PostoEntrega.codigoPostal LIKE '8000-316' AND Encomenda.idPostoEntrega = PostoEntrega.idPostoEntrega)
ORDER BY Pessoa.nome;    