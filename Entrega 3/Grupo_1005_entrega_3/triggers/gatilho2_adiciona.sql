PRAGMA foreign_keys = on;

-----OPERADORES

--Não permite adicionar um horário a um trabalhador que já está a trabalhar num intervalo de tempo coincidente
DROP TRIGGER IF EXISTS operadorDoisHorarios;
CREATE TRIGGER operadorDoisHorarios
BEFORE INSERT ON HorarioOperadorPosto
FOR EACH ROW
WHEN (EXISTS (SELECT * FROM 
(SELECT Horario.horaInicio as hora_inicio_existente, Horario.horaFim as hora_fim_existente
FROM Horario natural join HorarioOperadorPosto
WHERE HorarioOperadorPosto.idOperador = NEW.idOperador AND Horario.data = (SELECT Horario.data FROM Horario WHERE Horario.idHorario = NEW.idHorario))p,
(SELECT Horario.horaInicio as nova_hora_inicio, Horario.horaFim as nova_hora_fim FROM Horario WHERE Horario.idHorario = NEW.idHorario) q
WHERE (hora_inicio_existente BETWEEN nova_hora_inicio AND nova_hora_fim) OR (nova_hora_inicio BETWEEN hora_inicio_existente AND hora_fim_existente)))
BEGIN
    SELECT RAISE(ROLLBACK, "O operador de posto já se encontra a trabalhar nesse mesmo horário");
END;

--Não permite alterar um horário se a mudança coincidir com outro horário em que ele esteja a trabalhar
DROP TRIGGER IF EXISTS operadorDoisHorariosUpdate;
CREATE TRIGGER operadorDoisHorariosUpdate
BEFORE Update ON Horario
FOR EACH ROW
WHEN (EXISTS (SELECT * FROM 
(SELECT Horario.idHorario, Horario.horaInicio as hora_inicio_existente, Horario.horaFim as hora_fim_existente, HorarioOperadorPosto.idOperador
FROM Horario natural join HorarioOperadorPosto
where Horario.data = New.data AND HorarioOperadorPosto.idOperador in (Select HorarioOperadorPosto.idOperador from Horario natural join HorarioOperadorPosto where Horario.idHorario = new.idHorario))p
WHERE (hora_inicio_existente BETWEEN new.horaInicio AND NEW.horaFim) OR (NEW.horaInicio BETWEEN hora_inicio_existente AND hora_fim_existente)))
BEGIN
    SELECT RAISE(ROLLBACK, "Algum operador de posto já se encontra a trabalhar nesse mesmo horário");
END;

------CONDUTORES

--Não permite adicionar uma viagem a um condutor que já esteja a trabalhar num tempo coincidente
DROP TRIGGER IF EXISTS CondutorDoisHorarios;
CREATE TRIGGER CondutorDoisHorarios
BEFORE INSERT ON Viagem
FOR EACH ROW
WHEN (EXISTS (SELECT * FROM 
(SELECT Horario.horaInicio as hora_inicio_existente, Horario.horaFim as hora_fim_existente
FROM Horario natural join Viagem
WHERE Viagem.idCondutor = NEW.idCondutor AND Horario.data = (SELECT Horario.data FROM Horario WHERE Horario.idHorario = NEW.idHorario))p,
(SELECT Horario.horaInicio as nova_hora_inicio, Horario.horaFim as nova_hora_fim FROM Horario WHERE Horario.idHorario = NEW.idHorario) q
WHERE (hora_inicio_existente BETWEEN nova_hora_inicio AND nova_hora_fim) OR (nova_hora_inicio BETWEEN hora_inicio_existente AND hora_fim_existente)))
BEGIN
    SELECT RAISE(ROLLBACK, "O condutor já se encontra a trabalhar nesse mesmo horário");
END;

--Não permite alterar um horário que esteja associado a uma viagem se essa mudança coincidir com uma viagem de um qualquer condutor
DROP TRIGGER IF EXISTS condutorDoisHorariosUpdate;
CREATE TRIGGER condutorDoisHorariosUpdate
BEFORE Update ON Horario
FOR EACH ROW
WHEN (EXISTS (SELECT * FROM 
(SELECT Horario.idHorario, Horario.horaInicio as hora_inicio_existente, Horario.horaFim as hora_fim_existente, Viagem.idCondutor
FROM Horario natural join Viagem
where Horario.data = New.data AND Viagem.idCondutor in (Select Viagem.idCondutor from Horario natural join Viagem where Horario.idHorario = new.idHorario))p
WHERE (hora_inicio_existente BETWEEN new.horaInicio AND NEW.horaFim) OR (NEW.horaInicio BETWEEN hora_inicio_existente AND hora_fim_existente)))
BEGIN
    SELECT RAISE(ROLLBACK, "Algum condutor já se encontra a trabalhar nesse mesmo horário");
END;