PRAGMA foreign_keys = ON;

--Não deixar criar uma viagem em que o condutor não consegue conduzir o carro.
DROP TRIGGER IF EXISTS condutorPodeConduzir;
CREATE TRIGGER condutorPodeConduzir
AFTER INSERT ON Viagem
FOR EACH ROW
WHEN (SELECT Carro.idCategoria FROM Carro
WHERE Carro.idCarro = NEW.idCarro)
NOT IN (SELECT PodeConduzir.idCategoria
FROM Condutor natural join PodeConduzir
WHERE Condutor.idCondutor = NEW.idCondutor)
BEGIN
    SELECT RAISE(ROLLBACK, "O condutor não pode conduzir o carro especificado pois não é de uma categoria a que ele esteja habilitado a conduzir");
END;    

--Não deixar associar uma encomenda a uma viagem mais antiga ou que não passe nos postos de entrega e destino. 
DROP TRIGGER IF EXISTS encomendaEntregaDestino;
CREATE TRIGGER encomendaEntregaDestino
AFTER INSERT ON Encomenda
FOR EACH ROW
when (New.idPostoRecolha not in (Select idPostoEntrega from (Rota join PostoPertenceRota on Rota.idRota = PostoPertenceRota.idRota) join Viagem on Viagem.idRota = Rota.idRota
where Viagem.idViagem = new.idViagem)) OR (New.idPostoEntrega not in (Select idPostoEntrega from (Rota join PostoPertenceRota on Rota.idRota = PostoPertenceRota.idRota) join Viagem on Viagem.idRota = Rota.idRota
where Viagem.idViagem = new.idViagem))
BEGIN
    SELECT RAISE(ROLLBACK, "A viagem escolhida não passa nos postos de recolha e entrega da encomenda");
END;
