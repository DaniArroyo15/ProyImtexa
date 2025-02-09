---USE BD_SISMA
GO
-- RHWeb*_Papeleta
IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'Tienda_Cliente'))
BEGIN
	DROP TABLE dbo.Tienda_Cliente
	PRINT 'Table Delete : dbo.Tienda_Cliente';
	RETURN;
END
GO
-- TRUNCATE TABLE dbo.Tienda_Cliente
CREATE TABLE dbo.Tienda_Cliente
(
	 PK_eCliente		INT IDENTITY(1,1) CONSTRAINT PK_Tienda_Cliente PRIMARY KEY NOT NULL
	,vCodigo			AS 'C' + FORMAT(PK_eCliente,'000000')
	,vRazonSocial		VARCHAR(MAX)
	,vNombreComercial	VARCHAR(MAX)
	,vDireccion			VARCHAR(MAX)
	,vDocumento			VARCHAR(20)
	,vNroTelefono		VARCHAR(15)
	,vNroTelefonoAlt	VARCHAR(15)
	,FK_TDocumento		INT
	,FK_eUbigeo			INT
	-- LOG
	,bActivo			BIT
	,eUsuario			INT	
	,vEstado			VARCHAR(5)
	,dFecRegistro		DATETIME
	,vLogModify			VARCHAR(MAX)
	,vLogDelete			VARCHAR(MAX)
);
GO
--
ALTER TABLE dbo.Tienda_Cliente ADD CONSTRAINT DF_Tienda_Cliente_vEstado DEFAULT ('REG') FOR vEstado;
ALTER TABLE dbo.Tienda_Cliente ADD CONSTRAINT DF_Tienda_Cliente_dFecRegistro DEFAULT (GETDATE()) FOR dFecRegistro; 
ALTER TABLE dbo.Tienda_Cliente ADD CONSTRAINT DF_Tienda_Cliente_bActivo DEFAULT (1) FOR bActivo;
GO
--
IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'Tienda_Cliente'))
BEGIN
	PRINT 'Table Create : dbo.Tienda_Cliente';
END
GO
SELECT * FROM dbo.Tienda_Cliente