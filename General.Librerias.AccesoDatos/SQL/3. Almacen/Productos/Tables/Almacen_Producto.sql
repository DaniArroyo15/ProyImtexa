---USE BD_SISMA
GO
-- RHWeb*_Papeleta
IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'Almacen_Producto'))
BEGIN
	DROP TABLE dbo.Almacen_Producto
	PRINT 'Table Delete : dbo.Almacen_Producto';
	RETURN;
END
GO
-- TRUNCATE TABLE dbo.Almacen_Producto
CREATE TABLE dbo.Almacen_Producto
(
	 PK_eProducto		INT IDENTITY(1,1) CONSTRAINT PK_Almacen_Producto PRIMARY KEY NOT NULL
	,vCodigo			AS 'SKU-' + FORMAT(PK_eProducto,'00000000')
	,vAlias				VARCHAR(20)
	,vDescripcion		VARCHAR(MAX)
	,vObservacion		VARCHAR(MAX)
	,FK_eCategoria		INT
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
ALTER TABLE dbo.Almacen_Producto ADD CONSTRAINT DF_Almacen_Producto_vEstado		DEFAULT ('REG') FOR vEstado;
ALTER TABLE dbo.Almacen_Producto ADD CONSTRAINT DF_Almacen_Producto_dFecha		DEFAULT (GETDATE()) FOR dFecha; 
ALTER TABLE dbo.Almacen_Producto ADD CONSTRAINT DF_Almacen_Producto_bActivo		DEFAULT (1) FOR bActivo;
ALTER TABLE dbo.Almacen_Producto ADD CONSTRAINT DF_Almacen_Producto_eUsuario	DEFAULT (1) FOR eUsuario;
ALTER TABLE dbo.Almacen_Producto ADD CONSTRAINT DF_Almacen_Producto_eCategoria	DEFAULT (0) FOR FK_eCategoria;
GO
--
IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'Almacen_Producto'))
BEGIN
	PRINT 'Table Create : dbo.Almacen_Producto';
	--
	INSERT INTO dbo.Almacen_Producto (vAlias,vDescripcion,FK_eCategoria)
	SELECT 'ESPW','ELASTICO SPANDEX BLANCO',0

	INSERT INTO dbo.Almacen_Producto (vAlias,vDescripcion,FK_eCategoria)
	SELECT '100DNEG','NYLON 100D/2 NEGRO - BOBINAS',4

	INSERT INTO dbo.Almacen_Producto (vAlias,vDescripcion,FK_eCategoria)
	SELECT 'P701','LYCRA POLYESTER P701 BLANCO',0

	INSERT INTO dbo.Almacen_Producto (vAlias,vDescripcion,FK_eCategoria)
	SELECT '100DCOL','NYLON 100D/2 DISEÑO COLORES',4

	INSERT INTO dbo.Almacen_Producto (vAlias,vDescripcion,FK_eCategoria)
	SELECT '70DNEG','NYLON 70D/2 NEGRO - BOBINAS',4


	PRINT 'Table Insert : dbo.Almacen_Producto';
END
GO
SELECT * FROM dbo.Almacen_Producto