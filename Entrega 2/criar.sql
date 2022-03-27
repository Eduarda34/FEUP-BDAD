PRAGMA foreign_keys = on;

--Drop Tables
DROP TABLE IF EXISTS Encomenda;
DROP TABLE IF EXISTS Viagem;
DROP TABLE IF EXISTS Carro;
DROP TABLE IF EXISTS PodeConduzir;
DROP TABLE IF EXISTS Categoria;
DROP TABLE IF EXISTS Condutor;
DROP TABLE IF EXISTS PostoPertenceRota;
DROP TABLE IF EXISTS Rota;
DROP TABLE IF EXISTS HorarioOperadorPosto;
DROP TABLE IF EXISTS Horario;
DROP TABLE IF EXISTS OperadorPosto;
DROP TABLE IF EXISTS Funcionario;
DROP TABLE IF EXISTS PostoEntrega;
DROP TABLE IF EXISTS Cliente;
DROP TABLE IF EXISTS Pessoa;

--Table Pessoa
CREATE TABLE Pessoa(
    idPessoa INTEGER PRIMARY KEY,
    nome TEXT             CONSTRAINT pessoa_nome_nn NOT NULL,
    dataNascimento DATE   CONSTRAINT pessoa_dataNascimento_nn NOT NULL,
    morada TEXT           CONSTRAINT pessoa_morada_nn NOT NULL,
    mail TEXT             CONSTRAINT pessoa_mail_nn NOT NULL,
    telefone CHAR(9)      CONSTRAINT pessoa_telefone_nn NOT NULL 
                          CONSTRAINT pessoa_telefone_positive CHECK (telefone > 0),
    CONSTRAINT pessoa_idade_positiva CHECK(dataNascimento < DATE('now'))
);  

--Table Cliente
CREATE TABLE Cliente(
    idCliente INTEGER PRIMARY KEY 
                          CONSTRAINT fk_cliente_pessoa REFERENCES Pessoa (idPessoa) ON UPDATE CASCADE,
    nib INTEGER           CONSTRAINT cliente_nib_nn NOT NULL,
    nif INTEGER           CONSTRAINT cliente_nif_nn NOT NULL
);

--Table PostoEntrega
CREATE TABLE PostoEntrega(
    idPostoEntrega INTEGER PRIMARY KEY,
    codigoPostal CHAR(8) CONSTRAINT posto_entrega_codigo_postal_nn NOT NULL,
    morada TEXT          CONSTRAINT posto_entrega_morada_nn NOT NULL
);

--Table Funcionario
CREATE TABLE Funcionario(
    idFuncionario INTEGER PRIMARY KEY
                          CONSTRAINT fk_funcionario_pessoa REFERENCES Pessoa (idPessoa) ON UPDATE CASCADE,
    salario INTEGER       CONSTRAINT funcionario_salrio_nn NOT NULL
);

--Table OperadorPosto
CREATE TABLE OperadorPosto(
    idOperadorPosto INTEGER PRIMARY KEY 
                           CONSTRAINT fk_operador_funcionario REFERENCES Funcionario (idFuncionario) ON UPDATE CASCADE,
    idPostoEntrega INTEGER CONSTRAINT fk_operador_posto REFERENCES PostoEntrega (idPostoEntrega)     ON UPDATE CASCADE
);

--Table Horario
CREATE TABLE Horario(
    idHorario INTEGER PRIMARY KEY,
    data DATE            CONSTRAINT horario_date_nn NOT NULL,
    horaInicio TIME      CONSTRAINT horario_horaInicio_nn NOT NULL,
    horaFim TIME         CONSTRAINT horario_horaFim_nn NOT NULL,
    CONSTRAINT horario_unique_data_horas UNIQUE (data, horaInicio, horaFim),
    CONSTRAINT horario_check_fim_depois_inicio CHECK (horaFim > horaInicio) 
);

--Table HorarioOperadorPosto
CREATE TABLE HorarioOperadorPosto(
    idOperador INTEGER   CONSTRAINT fk_horario_operador_posto_operador REFERENCES OperadorPosto(idOperadorPosto) ON UPDATE CASCADE,
    idHorario  INTEGER   CONSTRAINT fk_horario_operador_posto_horario REFERENCES Horario(idHorario),
    PRIMARY KEY(idOperador, idHorario)                                                                                       
);

--Table Rota
CREATE TABLE Rota(
    idRota INTEGER PRIMARY KEY
);

--Table PostoPertenceRota
CREATE TABLE PostoPertenceRota(
    idRota INTEGER           CONSTRAINT fk_posto_pertence_rota_rota REFERENCES Rota(idRota),
    idPostoEntrega INTEGER   CONSTRAINT fk_posto_pertence_rota_postoentrega REFERENCES PostoEntrega(idPostoEntrega),
    lugarNaOrdem INTEGER,
    PRIMARY KEY(idPostoEntrega, idRota, lugarNaOrdem)                                                                                       
);

--Table Condutor
CREATE TABLE Condutor(
    idCondutor INTEGER PRIMARY KEY 
                            CONSTRAINT fk_condutor_funcionario REFERENCES Funcionario (idFuncionario) ON UPDATE CASCADE
);

--Table Categoria
CREATE TABLE Categoria(
    idCategoria INTEGER PRIMARY KEY,
    tipoCategoria TEXT CONSTRAINT categoria_tipo_categoria_nn NOT NULL
                       CONSTRAINT categoria_tipo_categoria_unique UNIQUE
);

 --Table PodeConduzir
CREATE TABLE PodeConduzir(
    idCondutor INTEGER  CONSTRAINT fk_pode_conduzir_condutor REFERENCES Condutor (idCondutor)    ON UPDATE CASCADE,
    idCategoria INTEGER CONSTRAINT fk_pode_conduzir_categoria REFERENCES Categoria (idCategoria) 
    PRIMARY KEY(idCondutor, idCategoria)
);

--Table Carro
CREATE TABLE Carro(
    idCarro INTEGER PRIMARY KEY,
    matricula CHAR(6)   CONSTRAINT carro_matricula_nn NOT NULL
                        CONSTRAINT carro_matricula_unique UNIQUE,
    marca CHAR(30)      CONSTRAINT carro_marca_nn NOT NULL,
    quilometros INTEGER CONSTRAINT carro_quilometros_nn NOT NULL,
    idCategoria INTEGER CONSTRAINT fk_carro_idCategoria REFERENCES Categoria(idCategoria)
); 

--Table Viagem
CREATE TABLE Viagem(
    idViagem INTEGER PRIMARY KEY,
    idRota     CONSTRAINT fk_viagem_rota REFERENCES Rota(idRota)             
               CONSTRAINT viagem_rota_nn NOT NULL,

    idCarro    CONSTRAINT fk_viagem_carro REFERENCES Carro(idCarro)          ON UPDATE CASCADE
               CONSTRAINT viagem_carro_nn NOT NULL,

    idCondutor CONSTRAINT fk_viagem_condutor REFERENCES Condutor(idCondutor) ON UPDATE CASCADE
               CONSTRAINT viagem_condutor_nn NOT NULL,

    idHorario  CONSTRAINT fk_viagem_horario REFERENCES Horario(idHorario)
               CONSTRAINT viagem_horario_nn NOT NULL
);

--Table Encomenda
CREATE TABLE Encomenda(
    idEncomenda INTEGER PRIMARY KEY,
    idPostoRecolha INTEGER   CONSTRAINT fk_encomenda_postoRecolha REFERENCES PostoEntrega (idPostoEntrega),
    idPostoEntrega INTEGER   CONSTRAINT fk_encomenda_postoEntrega REFERENCES PostoEntrega (idPostoEntrega), 

    idViagem INTEGER         CONSTRAINT fk_encomenda_viagem REFERENCES Viagem (idViagem)                     ON UPDATE CASCADE,
    idCliente INTEGER        CONSTRAINT fk_encomenda_cliente REFERENCES Cliente (idCliente)                  ON UPDATE CASCADE,

    dataPedido DATE          CONSTRAINT encomenda_dataPedido_nn NOT NULL,
    volume INTEGER           CONSTRAINT encomenda_volume_positive CHECK (volume > 0)
                             CONSTRAINT encomenda_volume_nn NOT NULL,
    peso INTEGER             CONSTRAINT encomenda_peso_positive CHECK (peso > 0)
                             CONSTRAINT encomenda_volume_nn NOT NULL,
    CONSTRAINT encomenda_postos_diferentes CHECK(idPostoRecolha <> idPostoEntrega)
);