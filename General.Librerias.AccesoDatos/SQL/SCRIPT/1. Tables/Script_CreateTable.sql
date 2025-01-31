/************* TABALAS DE SANTOOTH **********************/

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'Sistema_Catalogo'))
BEGIN
	DROP TABLE dbo.Sistema_Catalogo
	SELECT 'DROP TABLE : Sistema_Catalogo';
	RETURN;
END
GO
-- 
CREATE TABLE dbo.Sistema_Catalogo
(
	 eIdCatalogo			INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	 eIdCatalogoPadre		INT,
	 eIdGrupo				INT,
	 vDescripcion			VARCHAR(100),
	 dFechaRegistro			DATETIME,
	 vUsuarioRegistro		VARCHAR(MAX),
	 vIdPcRegistro			VARCHAR(20),
	 dFechaActualiza		DATETIME,
	 vUsuarioActualiza		INT,
	 vIdPcActualiza			VARCHAR(20),
	 bActivo				BIT
);
GO

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'Sistema_Modulo'))
BEGIN
	DROP TABLE dbo.Sistema_Modulo
	SELECT 'DROP TABLE : Sistema_Modulo';
	RETURN;
END
GO

CREATE TABLE dbo.Sistema_Modulo
(
	 eIdModulo				INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	 vNombre				VARCHAR(50),
	 dFechaRegistro			DATETIME,
	 vUsuarioRegistro		VARCHAR(MAX),
	 vIdPcRegistro			VARCHAR(20),
	 dFechaActualiza		DATETIME,
	 vUsuarioActualiza		VARCHAR(MAX),
	 vIdPcActualiza			VARCHAR(20),
	 bActivo				BIT
);
GO

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'Sistema_Opcion'))
BEGIN
	DROP TABLE dbo.Sistema_Opcion
	SELECT 'DROP TABLE : Sistema_Opcion';
	RETURN;
END
GO

CREATE TABLE dbo.Sistema_Opcion
(
	 eIdOpcion				INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	 eIdModulo				INT,
	 eIdOpcionPadre			INT,
	 vNombre				VARCHAR(100),
	 vRuta					VARCHAR(100),
	 vIcon					VARCHAR(50),
	 vNuOrden				VARCHAR(1),
	 dFechaRegistro			DATETIME,
	 vUsuarioRegistro		VARCHAR(MAX),
	 vIdPcRegistro			VARCHAR(20),
	 dFechaActualiza		DATETIME,
	 vUsuarioActualiza		VARCHAR(MAX),
	 vIdPcActualiza			VARCHAR(20),
	 bActivo				BIT
);
GO

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'Seguridad_Perfil'))
BEGIN
	DROP TABLE dbo.Seguridad_Perfil
	SELECT 'DROP TABLE : Seguridad_Perfil';
	RETURN;
END
GO

CREATE TABLE dbo.Seguridad_Perfil
(
	 eIdPerfil				INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	 vNombre				VARCHAR(100),
	 dFechaRegistro			DATETIME,
	 vUsuarioRegistro		VARCHAR(MAX),
	 vIdPcRegistro			VARCHAR(20),
	 dFechaActualiza		DATETIME,
	 vUsuarioActualiza		VARCHAR(MAX),
	 vIdPcActualiza			VARCHAR(20),
	 bActivo				BIT
);
GO

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'Seguridad_OpcionUsuario'))
BEGIN
	DROP TABLE dbo.Seguridad_OpcionUsuario
	SELECT 'DROP TABLE : Seguridad_OpcionUsuario';
	RETURN;
END
GO

CREATE TABLE dbo.Seguridad_OpcionUsuario
(
	 eIdPerfilOpcion		INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	 eIdOpcion				INT,
	 eIdUsuario				INT,
	 bVer					BIT,
	 bNuevo					BIT,
	 bEditar				BIT,
	 bGuardar				BIT,
	 bEliminar				BIT,
	 bImprimir				BIT,
	 bExportar				BIT,
	 dFechaRegistro			DATETIME,
	 vUsuarioRegistro		VARCHAR(MAX),
	 vIdPcRegistro			VARCHAR(20),
	 dFechaActualiza		DATETIME,
	 vUsuarioActualiza		VARCHAR(MAX),
	 vIdPcActualiza			VARCHAR(20),
	 bActivo				BIT
);
GO

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'Seguridad_Usuario'))
BEGIN
	DROP TABLE dbo.Seguridad_Usuario
	SELECT 'DROP TABLE : Seguridad_Usuario';
	RETURN;
END
GO

CREATE TABLE dbo.Seguridad_Usuario
(
	 eIdUsuario				INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	 eIdPersona				INT,
	 vUsuario				VARCHAR(100),
	 vClave					VARCHAR(100),
	 dFechaRegistro			DATETIME,
	 vUsuarioRegistro		VARCHAR(MAX),
	 vIdPcRegistro			VARCHAR(20),
	 dFechaActualiza		DATETIME,
	 vUsuarioActualiza		VARCHAR(MAX),
	 vIdPcActualiza			VARCHAR(20),
	 bActivo				BIT
);
GO

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'Seguridad_UsuarioPerfil'))
BEGIN
	DROP TABLE dbo.Seguridad_UsuarioPerfil
	SELECT 'DROP TABLE : Seguridad_UsuarioPerfil';
	RETURN;
END
GO

CREATE TABLE dbo.Seguridad_UsuarioPerfil
(
	 eIdUsuarioPerfil		INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	 eIdPerfil				INT,
	 eIdUsuario				INT,
	 dFechaRegistro			DATETIME,
	 vUsuarioRegistro		VARCHAR(MAX),
	 vIdPcRegistro			VARCHAR(20),
	 dFechaActualiza		DATETIME,
	 vUsuarioActualiza		VARCHAR(MAX),
	 vIdPcActualiza			VARCHAR(20),
	 bActivo				BIT
);
GO

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'General_Persona'))
BEGIN
	DROP TABLE dbo.General_Persona
	SELECT 'DROP TABLE : General_Persona';
	RETURN;
END
GO

CREATE TABLE dbo.General_Persona
(
	 eIdPersona				INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	 eIdCatalogo			INT,
	 vDni					VARCHAR(8),
	 vNombre				VARCHAR(100),
	 vApellidoPaterno		VARCHAR(100),
	 vApellidoMaterno		VARCHAR(100),
	 vIdCataSexo			VARCHAR(1),
	 vTelefono				VARCHAR(9),
	 vCorreo				VARCHAR(50),
	 vDireccion				VARCHAR(100),
	 vArchivoFoto			VARCHAR(100),
	 dFechaRegistro			DATETIME,
	 vUsuarioRegistro		VARCHAR(MAX),
	 vIdPcRegistro			VARCHAR(20),
	 dFechaActualiza		DATETIME,
	 vUsuarioActualiza		VARCHAR(MAX),
	 vIdPcActualiza			VARCHAR(20),
	 bActivo				BIT
);
GO

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'Tienda_Categoria'))
BEGIN
	DROP TABLE dbo.Tienda_Categoria
	SELECT 'DROP TABLE : Tienda_Categoria';
	RETURN;
END
GO

CREATE TABLE dbo.Tienda_Categoria
(
	 eIdCategoria			INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	 vNombre				VARCHAR(100),
	 vDescripcion			VARCHAR(100),
	 dFechaRegistro			DATETIME,
	 vUsuarioRegistro		VARCHAR(MAX),
	 vIdPcRegistro			VARCHAR(20),
	 dFechaActualiza		DATETIME,
	 vUsuarioActualiza		VARCHAR(MAX),
	 vIdPcActualiza			VARCHAR(20),
	 bActivo				BIT
);
GO



IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'Tienda_Producto'))
BEGIN
	DROP TABLE dbo.Tienda_Producto
	SELECT 'DROP TABLE : Tienda_Producto';
	RETURN;
END
GO

CREATE TABLE dbo.Tienda_Producto
(
	 eIdProducto			INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	 eIdCategoria			INT, 
	 vCodigo				VARCHAR(50), 
	 vDescripcion			VARCHAR(100),
	 dNeto					DECIMAL(10,2),
	 dBruto					DECIMAL(10,2),
	 dTara					DECIMAL(10,2),
	 vProveedor				VARCHAR(20),
	 vEstado				VARCHAR(20),
	 dFechaRegistro			DATETIME,
	 vUsuarioRegistro		VARCHAR(MAX),
	 vIdPcRegistro			VARCHAR(20),
	 dFechaActualiza		DATETIME,
	 vUsuarioActualiza		VARCHAR(MAX),
	 vIdPcActualiza			VARCHAR(20),
	 bActivo				BIT
);
GO


IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'Tienda_Venta'))
BEGIN
	DROP TABLE dbo.Tienda_Venta
	SELECT 'DROP TABLE : Tienda_Venta';
	RETURN;
END
GO

CREATE TABLE dbo.Tienda_Venta
(
	 eIdVenta				INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	 vCaTipDocumento		VARCHAR(3), -- doc cliente
	 vNumeroDocumento		VARCHAR(11),
	 vDireccion				VARCHAR(100),
	 vTelefono				VARCHAR(9),
	 vCaTipComprobante		VARCHAR(3), -- tipo de comprobante
	 vSerie					VARCHAR(10),
	 vNumeroComprobante		VARCHAR(10),
	 dImpuesto				DECIMAL(10,2),
	 dTotal					DECIMAL(10,2),
	 dFechaRegistro			DATETIME,
	 vUsuarioRegistro		VARCHAR(MAX),
	 vIdPcRegistro			VARCHAR(20),
	 dFechaActualiza		DATETIME,
	 vUsuarioActualiza		VARCHAR(MAX),
	 vIdPcActualiza			VARCHAR(20),
	 bActivo				BIT
);
GO

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'Tienda_DetalleVenta'))
BEGIN
	DROP TABLE dbo.Tienda_DetalleVenta
	SELECT 'DROP TABLE : Tienda_DetalleVenta';
	RETURN;
END
GO

CREATE TABLE dbo.Tienda_DetalleVenta
(
	 eIdDetalleVenta		INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	 eIdVenta				INT,
	 eIdProducto			INT,
	 eCantidad				INT,
	 dPrecio				DECIMAL(10,2),
	 dFechaRegistro			DATETIME,
	 vUsuarioRegistro		VARCHAR(MAX),
	 vIdPcRegistro			VARCHAR(20),
	 dFechaActualiza		DATETIME,
	 vUsuarioActualiza		VARCHAR(MAX),
	 vIdPcActualiza			VARCHAR(20),
	 bActivo				BIT
);
GO