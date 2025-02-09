--USE PROVIASNAC
--GO
SET NOCOUNT ON;
GO
IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'Sistema_Tablas'))
BEGIN
	DROP TABLE dbo.Sistema_Tablas
	PRINT 'Table Delete : dbo.Sistema_Tablas';
	RETURN;
END
GO
-- TRUNCATE TABLE dbo.Sistema_Tablas
CREATE TABLE dbo.Sistema_Tablas
(
	 PK_eTabla		INT CONSTRAINT PK_Sistema_Tablas PRIMARY KEY NOT NULL
	,vGrupo			VARCHAR(140)
	,vCodigo		VARCHAR(140)
	,vIcono			VARCHAR(200)
	,vNombre		VARCHAR(MAX)
	,vTag			VARCHAR(MAX)
	,vDescripcion	VARCHAR(MAX)
	,vValidacion	VARCHAR(MAX)
	,eOrden			INT
	,ePadre			INT
	-- LOG
	,bVisible		BIT
	,bActivo		BIT
	,eUsuario		INT	
	,vEstado		VARCHAR(5)
	,dFecha			DATETIME
	,vLogModify		VARCHAR(MAX)
	,vLogDelete		VARCHAR(MAX)
);
GO
ALTER TABLE dbo.Sistema_Tablas ADD CONSTRAINT DF_Sistema_Tablas_vEstado  DEFAULT ('REG') FOR vEstado;
ALTER TABLE dbo.Sistema_Tablas ADD CONSTRAINT DF_Sistema_Tablas_dFecha   DEFAULT (GETDATE()) FOR dFecha; 
ALTER TABLE dbo.Sistema_Tablas ADD CONSTRAINT DF_Sistema_Tablas_bActivo  DEFAULT (1) FOR bActivo;
ALTER TABLE dbo.Sistema_Tablas ADD CONSTRAINT DF_Sistema_Tablas_bVisible DEFAULT (1) FOR bVisible;
ALTER TABLE dbo.Sistema_Tablas ADD CONSTRAINT DF_Sistema_Tablas_eUsuario DEFAULT (1) FOR eUsuario;
GO
--
IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'Sistema_Tablas'))
BEGIN
	PRINT 'Table Create : dbo.Sistema_Tablas';
	--
	INSERT INTO dbo.Sistema_Tablas (PK_eTabla,vGrupo,vCodigo,vNombre)
	SELECT 1000,'TIP_PER','','Tipo de Persona'
	INSERT INTO dbo.Sistema_Tablas (PK_eTabla,vGrupo,vCodigo,vNombre,eOrden,ePadre)
	SELECT 1001,'TIP_PER','NAT','Natural',1,1000
	INSERT INTO dbo.Sistema_Tablas (PK_eTabla,vGrupo,vCodigo,vNombre,eOrden,ePadre)
	SELECT 1002,'TIP_PER','JUR','Juridica',2,1000
	--
	INSERT INTO dbo.Sistema_Tablas (PK_eTabla,vGrupo,vCodigo,vNombre)
	SELECT 1100,'TIP_TAR','','Tipo de Tarifas'
	INSERT INTO dbo.Sistema_Tablas (PK_eTabla,vGrupo,vCodigo,vNombre,eOrden,ePadre)
	SELECT 1101,'TIP_TAR','MULT','Multiple',1,1100
	INSERT INTO dbo.Sistema_Tablas (PK_eTabla,vGrupo,vCodigo,vNombre,eOrden,ePadre)
	SELECT 1102,'TIP_TAR','PER','Personalizada',2,1100
	--
	INSERT INTO dbo.Sistema_Tablas (PK_eTabla,vGrupo,vCodigo,vNombre)
	SELECT 1200,'TIP_OPE','','Tipo de Operacion'
	INSERT INTO dbo.Sistema_Tablas (PK_eTabla,vGrupo,vCodigo,vNombre,vTag,eOrden,ePadre)
	SELECT 1201,'TIP_OPE','ENT','Entrada','K',1,1200
	INSERT INTO dbo.Sistema_Tablas (PK_eTabla,vGrupo,vCodigo,vNombre,vTag,eOrden,ePadre)
	SELECT 1202,'TIP_OPE','SAL','Salida','K',2,1200
	INSERT INTO dbo.Sistema_Tablas (PK_eTabla,vGrupo,vCodigo,vNombre,eOrden,ePadre)
	SELECT 1203,'TIP_OPE','INI','Inventario Inicial',3,1200
	INSERT INTO dbo.Sistema_Tablas (PK_eTabla,vGrupo,vCodigo,vNombre,eOrden,ePadre)
	SELECT 1204,'TIP_OPE','INV','Inventario',4,1200
	--
	INSERT INTO dbo.Sistema_Tablas (PK_eTabla,vGrupo,vCodigo,vNombre)
	SELECT 1300,'TIP_DOC_OPE','','Tipo de Documento'
	INSERT INTO dbo.Sistema_Tablas (PK_eTabla,vGrupo,vCodigo,vNombre,eOrden,ePadre)
	SELECT 1301,'TIP_DOC_OPE','FAC','Factura',1,1300
	INSERT INTO dbo.Sistema_Tablas (PK_eTabla,vGrupo,vCodigo,vNombre,eOrden,ePadre)
	SELECT 1302,'TIP_DOC_OPE','BOL','Boleta',2,1300
	INSERT INTO dbo.Sistema_Tablas (PK_eTabla,vGrupo,vCodigo,vNombre,eOrden,ePadre)
	SELECT 1303,'TIP_DOC_OPE','GREM','Guía de Remisión',3,1300
	INSERT INTO dbo.Sistema_Tablas (PK_eTabla,vGrupo,vCodigo,vNombre,eOrden,ePadre)
	SELECT 1304,'TIP_DOC_OPE','GSAL','Guía de Salida',4,1300
	INSERT INTO dbo.Sistema_Tablas (PK_eTabla,vGrupo,vCodigo,vNombre,eOrden,ePadre)
	SELECT 1305,'TIP_DOC_OPE','OTR','Otro',5,1300
	--
	INSERT INTO dbo.Sistema_Tablas (PK_eTabla,vGrupo,vCodigo,vNombre)
	SELECT 1400,'TIP_DOC_IDE','','Tipo de Documento'
	INSERT INTO dbo.Sistema_Tablas (PK_eTabla,vGrupo,vCodigo,vNombre,vValidacion,eOrden,ePadre)
	SELECT 1401,'TIP_DOC_IDE','RUC','RUC','11',1,1400
	INSERT INTO dbo.Sistema_Tablas (PK_eTabla,vGrupo,vCodigo,vNombre,vValidacion,eOrden,ePadre)
	SELECT 1402,'TIP_DOC_IDE','DNI','Documento Nacional de Identidad','8',2,1400
	INSERT INTO dbo.Sistema_Tablas (PK_eTabla,vGrupo,vCodigo,vNombre,vValidacion,eOrden,ePadre)
	SELECT 1403,'TIP_DOC_IDE','CE','Carnet de Extranjeria','11',3,1400
	INSERT INTO dbo.Sistema_Tablas (PK_eTabla,vGrupo,vCodigo,vNombre,vValidacion,eOrden,ePadre)
	SELECT 1404,'TIP_DOC_IDE','OTR','Otro','150',4,1400
	--
	PRINT 'Table Insert : dbo.Sistema_Tablas';
	--
	SELECT * FROM dbo.Sistema_Tablas
END
GO
