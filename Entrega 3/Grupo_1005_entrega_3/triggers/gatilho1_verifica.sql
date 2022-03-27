.mode columns
.header on
.nullvalue NULL

PRAGMA foreign_keys = ON;

--TESTE DO GATILHO CONDUTORPODECONDUZIR

--'Tabela com os condutores e categorias que podem conduzir (ids)'

SELECT PodeConduzir.idCondutor, Carro.idCarro FROM PodeConduzir, Carro
WHERE Carro.idCategoria = PodeConduzir.idCategoria
ORDER BY PodeConduzir.idCondutor, Carro.idCarro;

--Adicionar uma viagem em que o Condutor não está qualificado

--'O condutor 24 não pode conduzir o carro 1'

INSERT INTO Viagem VALUES (13, 1, 1, 24, 10);

--Adicionar uma viagem em que o Condutor está qualificado

--'O condutor 23 pode conduzir o carro 1'

INSERT INTO Viagem VALUES (13, 1, 1, 23, 10);

--TESTE DO GATILHO encomendaEntregaDestino

--'Respetivos postos da viagem 5'

SELECT Viagem.idViagem, PostoPertenceRota.idPostoEntrega FROM Viagem, PostoPertenceRota
WHERE Viagem.idRota = PostoPertenceRota.idRota AND Viagem.idViagem LIKE 5
ORDER BY PostoPertenceRota.idPostoEntrega;

--'Inserir uma encomenda que cumpre com as condições'

Insert into Encomenda (idEncomenda, dataPedido, idPostoRecolha, idPostoEntrega, idViagem, idCliente) values(21,'2021-12-05',7,2,5,3);

--'Tentar inserir uma encomenda que não cumpre com as condições, tem como posto de entrega o posto 3, que não pertence à rota'

Insert into Encomenda (idEncomenda, dataPedido, idPostoRecolha, idPostoEntrega, idViagem, idCliente) values(22,'2021-12-05',7,3,5,3);


