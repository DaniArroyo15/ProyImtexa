---USE BD_SISMA
GO
-- RHWeb*_Papeleta
IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'Almacen_Kardex'))
BEGIN
	DROP TABLE dbo.Almacen_Kardex
	PRINT 'Table Delete : dbo.Almacen_Kardex';
	RETURN;
END
GO
-- TRUNCATE TABLE dbo.Almacen_Kardex
CREATE TABLE dbo.Almacen_Kardex
(
	 PK_eKardex			INT IDENTITY(1,1) CONSTRAINT PK_Almacen_Kardex PRIMARY KEY NOT NULL
	,vNroOperacion		AS 'OP' + FORMAT(PK_eKardex,'00000000')
	,vAlias				VARCHAR(20)
	,vLote				VARCHAR(MAX)
	,vDescripcion		VARCHAR(MAX)
	,vObservacion		VARCHAR(MAX)
	,eCantidad			INT
	,nValorUnitario		DECIMAL(10,2)
	,nValorTotal		AS nValorUnitario * eCantidad
	,FK_TOperacion		VARCHAR(4)	-- INI : Inicial, SAL : Salida, ENT : Entrada
	,FK_TDocumento		INT
	,FK_TDocumento		INT
	,FK_eProducto		INT
	-- LOG
	,bActivo			BIT
	,vEstado			VARCHAR(5)
	,eUsuario			INT	
	,dFecha				DATETIME
	,vLogModify			VARCHAR(MAX)
	,vLogDelete			VARCHAR(MAX)
);
GO
--
ALTER TABLE dbo.Almacen_Kardex ADD CONSTRAINT DF_Almacen_Kardex_vEstado		DEFAULT ('REG') FOR vEstado;
ALTER TABLE dbo.Almacen_Kardex ADD CONSTRAINT DF_Almacen_Kardex_dFecha		DEFAULT (GETDATE()) FOR dFecha; 
ALTER TABLE dbo.Almacen_Kardex ADD CONSTRAINT DF_Almacen_Kardex_bActivo		DEFAULT (1) FOR bActivo;
ALTER TABLE dbo.Almacen_Kardex ADD CONSTRAINT DF_Almacen_Kardex_eUsuario	DEFAULT (1) FOR eUsuario;
ALTER TABLE dbo.Almacen_Kardex ADD CONSTRAINT DF_Almacen_Kardex_eCategoria	DEFAULT (0) FOR FK_eCategoria;
GO
--
IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'Almacen_Kardex'))
BEGIN
	PRINT 'Table Create : dbo.Almacen_Kardex';
	--
	INSERT INTO dbo.Almacen_Kardex (vAlias,vDescripcion,FK_eCategoria)
	SELECT 'ESPW','ELASTICO SPANDEX BLANCO',0

	INSERT INTO dbo.Almacen_Kardex (vAlias,vDescripcion,FK_eCategoria)
	SELECT '100DNEG','NYLON 100D/2 NEGRO - BOBINAS',4

	INSERT INTO dbo.Almacen_Kardex (vAlias,vDescripcion,FK_eCategoria)
	SELECT 'P701','LYCRA POLYESTER P701 BLANCO',0

	INSERT INTO dbo.Almacen_Kardex (vAlias,vDescripcion,FK_eCategoria)
	SELECT '100DCOL','NYLON 100D/2 DISEÑO COLORES',4

	INSERT INTO dbo.Almacen_Kardex (vAlias,vDescripcion,FK_eCategoria)
	SELECT '70DNEG','NYLON 70D/2 NEGRO - BOBINAS',4


	PRINT 'Table Insert : dbo.Almacen_Kardex';
END
GO
SELECT * FROM dbo.Almacen_Kardex