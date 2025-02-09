---USE BD_SISMA
GO
-- RHWeb*_Papeleta
IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'Almacen_Categoria'))
BEGIN
	DROP TABLE dbo.Almacen_Categoria
	PRINT 'Table Delete : dbo.Almacen_Categoria';
	RETURN;
END
GO
-- TRUNCATE TABLE dbo.Almacen_Categoria
CREATE TABLE dbo.Almacen_Categoria
(
	 PK_eCategoria		INT IDENTITY(0,1) CONSTRAINT PK_Almacen_Categoria PRIMARY KEY NOT NULL
	,vCodigo			AS 'CT' + FORMAT(PK_eCategoria,'00')
	,vAlias				VARCHAR(20)
	,vNombre			VARCHAR(300)
	,vDescripcion		VARCHAR(MAX)
	-- LOG
	,bActivo			BIT
	,eUsuario			INT	
	,vEstado			VARCHAR(5)
	,dFecha				DATETIME
	,vLogModify			VARCHAR(MAX)
	,vLogDelete			VARCHAR(MAX)
);
GO
--
ALTER TABLE dbo.Almacen_Categoria ADD CONSTRAINT DF_Almacen_Categoria_vEstado DEFAULT ('REG') FOR vEstado;
ALTER TABLE dbo.Almacen_Categoria ADD CONSTRAINT DF_Almacen_Categoria_dFecha  DEFAULT (GETDATE()) FOR dFecha; 
ALTER TABLE dbo.Almacen_Categoria ADD CONSTRAINT DF_Almacen_Categoria_bActivo DEFAULT (1) FOR bActivo;
ALTER TABLE dbo.Almacen_Categoria ADD CONSTRAINT DF_Almacen_Categoria_eUsuario DEFAULT (1) FOR eUsuario;
GO
--
IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'Almacen_Categoria'))
BEGIN
	PRINT 'Table Create : dbo.Almacen_Categoria';
	--
	INSERT INTO Almacen_Categoria (vAlias,vNombre) SELECT 'GEN', 'Generico'
	INSERT INTO Almacen_Categoria (vAlias,vNombre) SELECT 'HIL', 'Hilos'
	INSERT INTO Almacen_Categoria (vAlias,vNombre) SELECT 'CON', 'Conos'
	INSERT INTO Almacen_Categoria (vAlias,vNombre) SELECT 'ALG', 'Algodón'
	INSERT INTO Almacen_Categoria (vAlias,vNombre) SELECT 'NYL', 'Nylon'
END
GO
SELECT * FROM dbo.Almacen_Categoria