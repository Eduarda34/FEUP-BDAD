.mode columns
.headers on
.nullvalue NULL

--Quais as viagens iniciadas entre o dia 06/12/2021 e o dia 08/12/2021? - 9
SELECT Viagem.idViagem, Horario.data, Horario.horaInicio
FROM Viagem
LEFT JOIN Horario
ON Viagem.idHorario = Horario.idHorario
WHERE Horario.data BETWEEN '2021-12-06' AND '2021-12-07'
ORDER BY Horario.data, Horario.horaInicio;