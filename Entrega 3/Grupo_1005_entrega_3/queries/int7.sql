.mode columns
.headers on
.nullvalue NULL

--Qual o tempo médio (em dias) que uma encomenda demora a ser entregue (do pedido à entrega ao cliente)? - 7
SELECT ROUND(AVG(p.diferenca_em_dias), 0) as media_diferenca_em_dias FROM
    (SELECT (julianday(Horario.data) - julianday(Encomenda.dataPedido)) AS diferenca_em_dias FROM Horario, Viagem, Encomenda
    WHERE Viagem.idHorario = Horario.idHorario AND Encomenda.idViagem = Viagem.idViagem) p
;