.mode columns
.headers on
.nullvalue NULL

--Número máximo de viagens por dia - 5
SELECT MAX(p.ViagemPorDia) AS numeroMaxViagens, p.data FROM
    (SELECT Horario.data, COUNT(*) AS ViagemPorDia FROM Viagem, Horario
    WHERE Viagem.idHorario = Horario.idHorario
    GROUP BY Horario.data) p
;