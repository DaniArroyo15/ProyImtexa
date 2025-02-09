---USE BD_SISMA
GO
-- RHWeb*_Papeleta
IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'Ventas_Tarifa'))
BEGIN
	DROP TABLE dbo.Ventas_Tarifa
	PRINT 'Table Delete : dbo.Ventas_Tarifa';
	RETURN;
END
GO
-- TRUNCATE TABLE dbo.Ventas_Tarifa
CREATE TABLE dbo.Ventas_Tarifa
(
	 PK_eTarifa		INT IDENTITY(0,1) CONSTRAINT PK_Ventas_Tarifa PRIMARY KEY NOT NULL
	,vCodigo		AS 'T' + FORMAT(PK_eTarifa,'00')
	,vNombre		VARCHAR(300)
	,vDescripcion	VARCHAR(MAX)
	,FK_TTarifa		INT
	-- LOG
	,bBloqueo		BIT
	,bActivo		BIT
	,eUsuario		INT	
	,vEstado		VARCHAR(5)
	,dFecha			DATETIME
	,vLogModify		VARCHAR(MAX)
	,vLogDelete		VARCHAR(MAX)
);
GO
--
ALTER TABLE dbo.Ventas_Tarifa ADD CONSTRAINT DF_Ventas_Tarifa_vEstado DEFAULT ('REG') FOR vEstado;
ALTER TABLE dbo.Ventas_Tarifa ADD CONSTRAINT DF_Ventas_Tarifa_dFecha  DEFAULT (GETDATE()) FOR dFecha; 
ALTER TABLE dbo.Ventas_Tarifa ADD CONSTRAINT DF_Ventas_Tarifa_bActivo DEFAULT (1) FOR bActivo;
ALTER TABLE dbo.Ventas_Tarifa ADD CONSTRAINT DF_Ventas_Tarifa_bBloqueo DEFAULT (0) FOR bBloqueo;
ALTER TABLE dbo.Ventas_Tarifa ADD CONSTRAINT DF_Ventas_Tarifa_eUsuario DEFAULT (1) FOR eUsuario;
GO
--
IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'Ventas_Tarifa'))
BEGIN
	PRINT 'Table Create : dbo.Ventas_Tarifa';
	--
	INSERT INTO Ventas_Tarifa (vNombre, vDescripcion, bBloqueo, FK_TTarifa) 
	SELECT 'Generico','Tarifa General',1,1101
	INSERT INTO Ventas_Tarifa (vNombre, vDescripcion, bBloqueo, FK_TTarifa) 
	SELECT 'Generico','Tarifa Personalizada',1,1102
END
GO
SELECT * FROM dbo.Ventas_Tarifa