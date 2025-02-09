--USE PROVIASNAC
GO
-- ==========================================================================================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==========================================================================================================================
-- Proyecto			:	RR.HH Web
-- Fecha Creación	:	
-- Descripcion		:	
-- Orden Servicio	:	--
-- Responsable		:	Guillermo Zambrano
-- ==========================================================================================================================
/*
	SELECT * FROM Almacen_Producto;
	SELECT * FROM Almacen_Categoria;

	EXEC paProducto_Listar
*/
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'paProducto_Listar')
BEGIN
	DROP PROCEDURE paProducto_Listar
	PRINT '***'
	PRINT 'SP Delete : paProducto_Listar';
END;
GO
CREATE Procedure dbo.paProducto_Listar
As
BEGIN
	SET NOCOUNT ON;
	SET DATEFORMAT YMD;
	SET ANSI_NULLS OFF;
	------------------//           
	---|
	DECLARE @vcMessage	 VARCHAR(MAX) = '';
	---|
	---| Variables de Corte
	DECLARE @vcSepRegistro	VARCHAR(1) = '¬';
	DECLARE @vcSepCampo		VARCHAR(1) = '|';
	DECLARE @vcSepTabla		VARCHAR(1) = '~';
	DECLARE @vcSepOpcional	VARCHAR(1) = '^';
	DECLARE @vcSepValor		VARCHAR(1) = ',';
	--|
	DECLARE @vcRetorno		VARCHAR(MAX);
	DECLARE @vcCabecera		VARCHAR(MAX);
	DECLARE @vcRegistros	VARCHAR(MAX);
	--|
	SET @vcCabecera =  'Id|Codigo|Categoria|Alias|Descripción|Observación|Fec. Registro|Estado'
	+ @vcSepRegistro + '50|100|120|100|300|300|100|100' 
	+ @vcSepRegistro + 'String|String|String|String|String|String|String|String';
	--|
	SET @vcRegistros =  ISNULL((SELECT STUFF ((
												SELECT		@vcSepRegistro + CONVERT(VARCHAR(20), PRO.PK_eProducto)
															+ @vcSepCampo + PRO.vCodigo
															+ @vcSepCampo + UPPER(ISNULL(CAT.vNombre,''))
															+ @vcSepCampo + ISNULL(PRO.vAlias,'')
															+ @vcSepCampo + ISNULL(PRO.vDescripcion,'')
															+ @vcSepCampo + ISNULL(PRO.vObservacion,'')
															+ @vcSepCampo + FORMAT(PRO.dFecha, 'dd/MM/yyyy')
															+ @vcSepCampo + CASE WHEN PRO.bActivo = '1' THEN 'Activo' ELSE 'Inactivo' END
												FROM		dbo.Almacen_Producto (NOLOCK) AS PRO
												INNER JOIN  dbo.Almacen_Categoria (NOLOCK) AS CAT
														ON	PRO.FK_eCategoria = CAT.PK_eCategoria
												WHERE		PRO.vEstado = 'REG'
								FOR XML PATH('')),1,1,'')),'')
	--|
	SET @vcRetorno =	CASE 
					WHEN @vcRegistros = '' 
					THEN @vcCabecera 
					ELSE @vcCabecera + @vcSepRegistro + @vcRegistros 
					END
	--|
	SELECT @vcRetorno;
END;
GO
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'paProducto_Listar')
BEGIN
	--GRANT EXECUTE ON dbo.paProducto_Listar TO dbUser;
	PRINT 'SP Create : paProducto_Listar';
	PRINT '***'
END
GO