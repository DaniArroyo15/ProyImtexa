---USE BD_SISMA
GO
-- RHWeb*_Papeleta
IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'Ventas_Venta'))
BEGIN
	DROP TABLE dbo.Ventas_Venta
	PRINT 'Table Delete : dbo.Ventas_Venta';
	RETURN;
END
GO
-- TRUNCATE TABLE dbo.Ventas_Venta
CREATE TABLE dbo.Ventas_Venta
(
	 PK_eVenta			INT IDENTITY(1,1) CONSTRAINT PK_Ventas_Venta PRIMARY KEY NOT NULL
	,vCodigo			AS 'V' + FORMAT(PK_eVenta,'0000')
	,FK_eCliente		INT
	,FK_eTVenta			INT
	,FK_eTPago			INT
	,FK_eTDocumento		INT
	,vNroDocumento		VARCHAR(10)
	,vObservacion		VARCHAR(MAX)
	,nSubTotal			DECIMAL(10,2)
	,nIGV				DECIMAL(10,2)
	,nTotalIGV			DECIMAL(10,2)
	,nTotalDescuentos	DECIMAL(10,2)
	,nTotalAumentos		DECIMAL(10,2)
	,nTotal				DECIMAL(10,2)
	,nDiasCredito		INT
	,FK_eTEntrega		INT
	-- LOG
	,bBloqueo			BIT
	,bActivo			BIT
	,eUsuario			INT	
	,vEstado			VARCHAR(5)
	,dFecha				DATETIME
	,vLogModify			VARCHAR(MAX)
	,vLogDelete			VARCHAR(MAX)
);
GO
--
ALTER TABLE dbo.Ventas_Venta ADD CONSTRAINT DF_Ventas_Venta_vEstado DEFAULT ('REG') FOR vEstado;
ALTER TABLE dbo.Ventas_Venta ADD CONSTRAINT DF_Ventas_Venta_dFecha  DEFAULT (GETDATE()) FOR dFecha; 
ALTER TABLE dbo.Ventas_Venta ADD CONSTRAINT DF_Ventas_Venta_bActivo DEFAULT (1) FOR bActivo;
ALTER TABLE dbo.Ventas_Venta ADD CONSTRAINT DF_Ventas_Venta_bBloqueo DEFAULT (0) FOR bBloqueo;
ALTER TABLE dbo.Ventas_Venta ADD CONSTRAINT DF_Ventas_Venta_eUsuario DEFAULT (1) FOR eUsuario;
GO
--
IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'Ventas_Venta'))
BEGIN
	PRINT 'Table Create : dbo.Ventas_Venta';
END
GO
SELECT * FROM dbo.Ventas_Venta
SELECT * FROM dbo.Ventas_Cliente