.mode columns
.headers on
.nullvalue NULL

--Qual o condutor, a hora e a matricula do carro da viagem com mais paragens? - 10
SELECT Viagem.idViagem, V.numParagens, Pessoa.nome as nome_condutor, Carro.matricula, Horario.data, Horario.horaInicio, Horario.horaFim
FROM Pessoa, Carro, Horario, Viagem,
    (SELECT Viagem.idViagem, p.numParagens 
    FROM Viagem, 
    (SELECT PostoPertenceRota.idRota, COUNT(*) AS numParagens 
        FROM PostoPertenceRota
        GROUP BY PostoPertenceRota.idRota
        HAVING numParagens = (
            SELECT COUNT(*) AS max FROM PostoPertenceRota
            GROUP BY PostoPertenceRota.idRota
            ORDER BY COUNT(*) DESC
            LIMIT 1)
        )p   
    WHERE Viagem.idRota = p.idRota) V
WHERE V.idViagem = Viagem.idViagem AND Viagem.idCondutor = Pessoa.idPessoa AND Viagem.idCarro = Carro.idCarro AND Viagem.idHorario = Horario.idHorario
ORDER BY Horario.data, Horario.horaInicio
;