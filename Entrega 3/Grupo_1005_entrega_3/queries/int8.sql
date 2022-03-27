.mode columns
.headers on
.nullvalue NULL

--Qual o posto com mais operadores num mesmo dia? - 8
Select q.idPostoEntrega, q.morada, q.data,max(q.num_funcionarios) as max_funcionarios from(
Select PostoEntrega.idPostoEntrega, PostoEntrega.morada, Horario.data,count(OperadorPosto.idOperadorPosto) as num_funcionarios from PostoEntrega,Horario,OperadorPosto,HorarioOperadorPosto
Where OperadorPosto.idOperadorPosto = HorarioOperadorPosto.idOperador AND Horario.idHorario = HorarioOperadorPosto.idHorario AND OperadorPosto.idPostoEntrega = PostoEntrega.idPostoEntrega
Group by PostoEntrega.idPostoEntrega,Horario.data) q;