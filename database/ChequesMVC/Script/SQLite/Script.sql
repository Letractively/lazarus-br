CREATE TABLE [mes] 
(
    [oid] INTEGER CONSTRAINT "pk_oidmes" NOT NULL PRIMARY KEY AUTOINCREMENT,
    [nome] VARCHAR(9) NOT NULL
);

CREATE TABLE [banco] 
(
    [oid] INTEGER CONSTRAINT "pk_oidbanco" NOT NULL PRIMARY KEY AUTOINCREMENT,
    [codigo] VARCHAR(10),
    [nome] VARCHAR(20) NOT NULL,
    [agencia] VARCHAR(10)
);

CREATE TABLE [conta] 
(
    [oid] INTEGER CONSTRAINT "pk_oidconta" NOT NULL PRIMARY KEY AUTOINCREMENT,
    [nome] VARCHAR(10) NOT NULL
);

CREATE TABLE [destino]
(
    [oid] INTEGER CONSTRAINT "pk_oiddestino" NOT NULL PRIMARY KEY AUTOINCREMENT,
    [nome] VARCHAR(50) NOT NULL, [endereco] VARCHAR(30), [cpf] VARCHAR(11),
    [telefone] VARCHAR(10), [celular] VARCHAR(10), [email] VARCHAR(50)
);

CREATE TABLE [cheque]
(
    [oid] INTEGER CONSTRAINT "pk_oidcheque" NOT NULL PRIMARY KEY AUTOINCREMENT,
    [oidbanco] INTEGER CONSTRAINT "fk_oidbanco_cheque" NOT NULL REFERENCES [banco](oid) ON DELETE RESTRICT,
    [oidconta] INTEGER CONSTRAINT "fk_oidconta_cheque" NOT NULL REFERENCES [conta](oid) ON DELETE RESTRICT,
    [oiddestino] INTEGER CONSTRAINT "fk_oiddestino_cheque" NOT NULL REFERENCES [destino](oid) ON DELETE RESTRICT,
    [numero] VARCHAR(10),
    [vencimento] DATE NOT NULL,
    [oidmes] INTEGER CONSTRAINT "fk_oidmes" NOT NULL REFERENCES [mes](oid) ON DELETE RESTRICT,
    [valor] NUMERIC(17,4) NOT NULL,
    [pago] BOOLEAN DEFAULT 'f'
);

CREATE TRIGGER [fk_cheque_banco] BEFORE DELETE ON [banco] WHEN (old.[oid] IN (SELECT [oidbanco] FROM [cheque] GROUP BY [oidbanco])) BEGIN
SELECT RAISE( ABORT, 'Foreign key violated: fk_cheque_banco' );
END;

CREATE TRIGGER [fk_cheque_conta] BEFORE DELETE ON [conta] WHEN (old.[oid] IN (SELECT [oidconta] FROM [cheque] GROUP BY [oidconta])) BEGIN
SELECT RAISE( ABORT, 'Foreign key violated: fk_cheque_conta' );
END;

CREATE TRIGGER [fk_cheque_mes] BEFORE DELETE ON [mes] WHEN (old.[oid] IN (SELECT [oidmes] FROM [cheque] GROUP BY [oidmes])) BEGIN
SELECT RAISE( ABORT, 'Foreign key violated: fk_cheque_mes' );
END;

CREATE TRIGGER [fk_cheque_destino] BEFORE DELETE ON [destino] WHEN (old.[oid] IN (SELECT [oiddestino] FROM [cheque] GROUP BY [oiddestino])) BEGIN
SELECT RAISE( ABORT, 'Foreign key violated: fk_cheque_destino' );
END;

