---USE BD_SISMA
GO
-- RHWeb*_Papeleta
IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'Almacen_Proveedor'))
BEGIN
	DROP TABLE dbo.Almacen_Proveedor
	PRINT 'Table Delete : dbo.Almacen_Proveedor';
	RETURN;
END
GO
-- TRUNCATE TABLE dbo.Almacen_Proveedor
CREATE TABLE dbo.Almacen_Proveedor
(
	 PK_eProveedor		INT IDENTITY(1,1) CONSTRAINT PK_Almacen_Proveedor PRIMARY KEY NOT NULL
	,vCodigo			AS 'P' + FORMAT(PK_eProveedor,'0000')
	,vAlias				VARCHAR(20)
	,vRazonSocial		VARCHAR(300)
	,vRUC				VARCHAR(25)
	,vTelefono			VARCHAR(150)
	,vCorreo			VARCHAR(150)
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
ALTER TABLE dbo.Almacen_Proveedor ADD CONSTRAINT DF_Almacen_Proveedor_vEstado DEFAULT ('REG') FOR vEstado;
ALTER TABLE dbo.Almacen_Proveedor ADD CONSTRAINT DF_Almacen_Proveedor_dFecha  DEFAULT (GETDATE()) FOR dFecha; 
ALTER TABLE dbo.Almacen_Proveedor ADD CONSTRAINT DF_Almacen_Proveedor_bActivo DEFAULT (1) FOR bActivo;
GO
--
IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'Almacen_Proveedor'))
BEGIN
	PRINT 'Table Create : dbo.Almacen_Proveedor';
END
GO
SELECT * FROM dbo.Almacen_Proveedor