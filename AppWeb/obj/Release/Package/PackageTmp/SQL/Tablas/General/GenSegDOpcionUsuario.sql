USE BD_SISMA
GO
--
IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'GenSegDOpcionUsuario'))
BEGIN
	DROP TABLE dbo.GenSegDOpcionUsuario
	PRINT 'Table Delete : dbo.GenSegDOpcionUsuario';
	RETURN;
END
GO
--
CREATE TABLE dbo.GenSegDOpcionUsuario
(
	 PK_eOpcionUsuario	INT IDENTITY(1,1) CONSTRAINT PK_eOpcionUsuario_GenSegDOpcionUsuario PRIMARY KEY NOT NULL
	,eOpcion			INT
	,ePersona			INT
	,cEstado			VARCHAR(5)
	,fRegistro			DATETIME
	,cLogDelete			VARCHAR(MAX)
);
GO
--
ALTER TABLE dbo.GenSegDOpcionUsuario ADD CONSTRAINT DF_GenSegDOpcionUsuario_cEstado DEFAULT ('REG') FOR cEstado;
ALTER TABLE dbo.GenSegDOpcionUsuario ADD CONSTRAINT DF_GenSegDOpcionUsuario_fRegistro DEFAULT (GETDATE()) FOR fRegistro; 
GO
--
IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'GenSegDOpcionUsuario'))
BEGIN
	PRINT 'Table Create : dbo.GenSegDOpcionUsuario';
	--
	INSERT INTO dbo.GenSegDOpcionUsuario (eOpcion,ePersona) SELECT 1000,132533
	INSERT INTO dbo.GenSegDOpcionUsuario (eOpcion,ePersona) SELECT 1010,132533
	INSERT INTO dbo.GenSegDOpcionUsuario (eOpcion,ePersona) SELECT 1011,132533
	INSERT INTO dbo.GenSegDOpcionUsuario (eOpcion,ePersona) SELECT 1012,132533
END
GO
--
SELECT * FROM GenSegDOpcionUsuario