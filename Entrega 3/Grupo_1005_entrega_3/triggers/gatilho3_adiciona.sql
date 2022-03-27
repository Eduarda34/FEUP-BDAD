PRAGMA foreign_keys = ON;

--Sempre que se adiciona uma caixa a uma encomenda, incrementar o valor da encomenda
DROP TRIGGER IF EXISTS adicionaCaixaEncomenda ;
CREATE TRIGGER adicionaCaixaEncomenda
AFTER INSERT ON Caixa
FOR EACH ROW
BEGIN
   UPDATE Encomenda 
   SET valor = valor + NEW.peso * NEW.volume
   WHERE idEncomenda = NEW.idEncomenda;
END;

--Sempre que se altera o volume e o peso de uma caixa, deve ser alterado o valor da encomenda.
DROP TRIGGER IF EXISTS updateCaixaEncomenda ;
CREATE TRIGGER updateCaixaEncomenda
AFTER UPDATE ON Caixa
FOR EACH ROW
BEGIN
   UPDATE Encomenda 
   SET valor = valor - (OLD.peso * OLD.volume) + NEW.peso * NEW.volume
   WHERE OLD.idEncomenda = NEW.idEncomenda;
END;

--Sempre que se remova uma caixa, ao valor da encomenda será retirado o valor da caixa
DROP TRIGGER IF EXISTS deleteCaixaEncomenda ;
CREATE TRIGGER deleteCaixaEncomenda
AFTER DELETE ON Caixa
FOR EACH ROW
BEGIN
   UPDATE Encomenda 
   SET valor = valor - (OLD.peso * OLD.volume)
   WHERE Encomenda.idEncomenda = OLD.idEncomenda;
END;

--Quando a encomenda apenas tiver uma caixa e essa caixa tiver sido eliminada, a encomenda é eliminada
DROP TRIGGER IF EXISTS deleteCaixadeleteEncomenda ;
CREATE TRIGGER deleteCaixadeleteEncomenda
AFTER DELETE ON Caixa
FOR EACH ROW
when not exists(select * from Caixa where Caixa.idEncomenda = OLD.idEncomenda)
BEGIN
   Delete from Encomenda where idEncomenda = OLD.idEncomenda;
END;

--Quando se apaga uma encomenda, sendo esta a única do cliente, ele é removido da tabela de clientes
DROP TRIGGER IF EXISTS deleteEncomendaDeleteCliente;
CREATE TRIGGER deleteEncomendaDeleteCliente
AFTER DELETE ON Encomenda
FOR EACH ROW
when not exists(select * from Encomenda where Encomenda.idCliente = OLD.idCliente)
BEGIN
   Delete from Cliente where idCliente = OLD.idCliente;
END;