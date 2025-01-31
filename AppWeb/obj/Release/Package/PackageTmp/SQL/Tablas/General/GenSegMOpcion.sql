USE BD_SISMA
GO
--
IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'GenSegMOpcion'))
BEGIN
	DROP TABLE dbo.GenSegMOpcion
	PRINT 'Table Delete : dbo.GenSegMOpcion';
	RETURN;
END
GO
--
CREATE TABLE dbo.GenSegMOpcion
(
	 PK_eOpcion	INT CONSTRAINT PK_eOpcion_GenSegMOpcion PRIMARY KEY NOT NULL
	,cIdOpcion	VARCHAR(50)
	,cAlias		VARCHAR(100)
	,cNombre	VARCHAR(250)
	,cIcono		VARCHAR(50)
	,cUrl		VARCHAR(100)
	,eNivel		INT
	,eIdPadre	INT
	,eIdOrden	INT
	,bVisible	BIT
	,bMenu		BIT
	,eModulo	INT
	,cEstado	VARCHAR(5)
	,fRegistro	DATETIME
	,cLogModify	VARCHAR(MAX)
	,cLogDelete	VARCHAR(MAX)
);
GO
--
ALTER TABLE dbo.GenSegMOpcion ADD CONSTRAINT DF_GenSegMOpcion_bVisible DEFAULT ( 1 ) FOR bVisible; 
ALTER TABLE dbo.GenSegMOpcion ADD CONSTRAINT DF_GenSegMOpcion_cEstado DEFAULT ('REG') FOR cEstado;
ALTER TABLE dbo.GenSegMOpcion ADD CONSTRAINT DF_GenSegMOpcion_fRegistro DEFAULT (GETDATE()) FOR fRegistro; 
ALTER TABLE dbo.GenSegMOpcion ADD CONSTRAINT DF_GenSegMOpcion_bMenu DEFAULT (1) FOR bMenu;
ALTER TABLE dbo.GenSegMOpcion ADD CONSTRAINT DF_GenSegMOpcion_eIdPadre DEFAULT (0) FOR eIdPadre;
ALTER TABLE dbo.GenSegMOpcion ADD CONSTRAINT DF_GenSegMOpcion_eNivel DEFAULT (1) FOR eNivel;
GO
--
IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'GenSegMOpcion'))
BEGIN
	PRINT 'Table Create : dbo.GenSegMOpcion';
	--
	INSERT INTO dbo.GenSegMOpcion (PK_eOpcion,cIdOpcion,cIcono,cNombre,cAlias,cUrl,eIdOrden)
	SELECT 1000,'CONSEL','bx bx-task','Convocatoria y Selección','Convocatoria','',1
	INSERT INTO dbo.GenSegMOpcion (PK_eOpcion,cIdOpcion,cIcono,cNombre,cAlias,cUrl,eIdOrden,eIdPadre,eNivel)
	SELECT 1010,'CONSEL.CONV','bx bx-task','Convocatoria','CONV','Convocatoria/_Convocatoria/Index',1,1000,2
	INSERT INTO dbo.GenSegMOpcion (PK_eOpcion,cIdOpcion,cIcono,cNombre,cAlias,cUrl,eIdOrden,eIdPadre,eNivel)
	SELECT 1011,'CONSEL.EVA','bx bx-task','Evaluación','EVA','Convocatoria/_Evaluacion/Index',2,1000,2
	INSERT INTO dbo.GenSegMOpcion (PK_eOpcion,cIdOpcion,cIcono,cNombre,cAlias,cUrl,eIdOrden,eIdPadre,eNivel)
	SELECT 1012,'CONSEL.DEMO','bx bx-task','Selección','SEL','Convocatoria/_Seleccion/Index',3,1000,2
END
GO
--
SELECT * FROM GenSegMOpcion