.mode columns
.header on
.nullvalue NULL

PRAGMA foreign_keys = ON;

--TESTE DO GATILHO operadorDoisHorarios

--'Tabela com as datas e horas a que o operador 6 está a trabalhar'
SELECT HorarioOperadorPosto.idOperador, Horario.data, Horario.horaInicio, Horario.horaFim
FROM HorarioOperadorPosto, Horario
WHERE HorarioOperadorPosto.idHorario = Horario.idHorario AND HorarioOperadorPosto.idOperador LIKE 6
ORDER BY data, horaInicio;


--Não deveria inserir, nem insere
INSERT INTO HorarioOperadorPosto VALUES(6, 10);
--Deveria inserir, e insere
INSERT INTO HorarioOperadorPosto VALUES(6, 15);


--TESTE DO GATILHO operadorDoisHorariosUpdate

--Tabela com os horários de operadores que ficariam com horários sobrepostos perante a mudança de horário
SELECT * FROM 
(SELECT Horario.idHorario, Horario.horaInicio as hora_inicio_existente, Horario.horaFim as hora_fim_existente, HorarioOperadorPosto.idOperador
FROM Horario natural join HorarioOperadorPosto
where Horario.data = '2022-12-13' AND HorarioOperadorPosto.idOperador in (Select HorarioOperadorPosto.idOperador from Horario natural join HorarioOperadorPosto where Horario.idHorario = 7))p
WHERE (hora_inicio_existente BETWEEN '12:00:00' AND '14:00:00') OR ('12:00:00' BETWEEN hora_inicio_existente AND hora_fim_existente);

--Como não existe nenhum horário, é possível mudar o horário 7 para essa data
Update Horario set data = '2022-12-13',horaInicio = '12:00:00', horaFim = '14:00:00' where idHorario = 7;

--TESTE DO GATILHO CondutorDoisHorarios

--Tabela para quando o condutor 28 está em viagem
SELECT Horario.data, Horario.horaInicio, Horario.horaFim FROM Horario natural join Viagem
WHERE Viagem.idCondutor = 28;

--Horario id = 10
SELECT * FROM Horario WHERE Horario.idHorario = 10;
--Deveria inserir, e insere
INSERT INTO Viagem (idViagem, idRota, idCarro, idCondutor, idHorario) VALUES(14,6,10,28,10);

--Horario id = 3
SELECT * FROM Horario WHERE Horario.idHorario = 3;
--Não deve inserir
INSERT INTO Viagem (idViagem, idRota, idCarro, idCondutor, idHorario) VALUES(15,6,10,28,3);

--TESTE DO GATILHO condutorDoisHorariosUpdate

--Tabela com condutores que ficariam com horários sobrepostos perante a mudança de horário
SELECT * FROM 
(SELECT Horario.idHorario, Horario.horaInicio as hora_inicio_existente, Horario.horaFim as hora_fim_existente, Viagem.idCondutor
FROM Horario natural join Viagem
where Horario.data = '2021-12-08' AND Viagem.idCondutor in (Select Viagem.idCondutor from Horario natural join Viagem where Horario.idHorario = 13))p
WHERE (hora_inicio_existente BETWEEN '12:00:00' AND '14:00:00') OR ('12:00:00' BETWEEN hora_inicio_existente AND hora_fim_existente);

--Não deve atualizar nem atualiza
Update Horario set data = '2021-12-08',horaInicio = '12:00:00', horaFim = '14:00:00' where idHorario = 13;