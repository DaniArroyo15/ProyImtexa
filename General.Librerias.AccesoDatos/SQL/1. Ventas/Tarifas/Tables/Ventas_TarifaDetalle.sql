---USE BD_SISMA
GO
-- RHWeb*_Papeleta
IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'Ventas_TarifaDetalle'))
BEGIN
	DROP TABLE dbo.Ventas_TarifaDetalle
	PRINT 'Table Delete : dbo.Ventas_TarifaDetalle';
	RETURN;
END
GO
-- TRUNCATE TABLE dbo.Ventas_TarifaDetalle
CREATE TABLE dbo.Ventas_TarifaDetalle
(
	 FK_eTarifa		INT
	,FK_eProducto	INT
	,FK_eCliente	INT
	,vPrecio		INT
	,vObservacion	VARCHAR(MAX)
	-- LOG
	,bActivo		BIT
	,eUsuario		INT	
	,vEstado		VARCHAR(5)
	,dFecha			DATETIME
	,vLogModify		VARCHAR(MAX)
	,vLogDelete		VARCHAR(MAX)
);
GO
--
ALTER TABLE dbo.Ventas_TarifaDetalle ADD CONSTRAINT DF_Ventas_TarifaDetalle_vEstado DEFAULT ('REG') FOR vEstado;
ALTER TABLE dbo.Ventas_TarifaDetalle ADD CONSTRAINT DF_Ventas_TarifaDetalle_dFecha  DEFAULT (GETDATE()) FOR dFecha; 
ALTER TABLE dbo.Ventas_TarifaDetalle ADD CONSTRAINT DF_Ventas_TarifaDetalle_bActivo DEFAULT (1) FOR bActivo;
ALTER TABLE dbo.Ventas_TarifaDetalle ADD CONSTRAINT DF_Ventas_TarifaDetalle_eUsuario DEFAULT (1) FOR eUsuario;
GO
--
IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'Ventas_TarifaDetalle'))
BEGIN
	PRINT 'Table Create : dbo.Ventas_TarifaDetalle';
END
GO
SELECT * FROM dbo.Ventas_TarifaDetalle