.mode columns
.headers on
.nullvalue NULL

--Qual o tipo de trabalhador com a menor média salarial? - 3
SELECT IIF(min(op.salarioOperadorPosto, c.salarioCondutor) = op.salarioOperadorPosto,'Operador Posto','Condutor') as tipo_trabalhador, ROUND(min(op.salarioOperadorPosto, c.salarioCondutor),2) as menor_media FROM(
    (SELECT avg(salario) AS salarioOperadorPosto FROM Funcionario, OperadorPosto
    WHERE Funcionario.idFuncionario = OperadorPosto.idOperadorPosto) op,
    (SELECT avg(salario) AS salarioCondutor FROM Funcionario, Condutor
    WHERE Funcionario.idFuncionario = Condutor.idCondutor) c
);