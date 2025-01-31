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
	SELECT * FROM Tienda_Categoria;

	EXEC paCategorias_Listar
*/
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'paCategorias_Listar')
BEGIN
	DROP PROCEDURE paCategorias_Listar
	PRINT '***'
	PRINT 'SP Delete : paCategorias_Listar';
END;
GO
CREATE Procedure dbo.paCategorias_Listar
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
	SET @vcCabecera =  'Id|Nombre|Descripcion|Fec. Registro|Estado'
	+ @vcSepRegistro + '50|100|200|100|100' 
	+ @vcSepRegistro + 'String|String|String|String|String';
	--|
	SET @vcRegistros =  ISNULL((SELECT STUFF ((
												SELECT @vcSepRegistro + convert(varchar(10), eIdCategoria)
														+ @vcSepCampo + vNombre
														+ @vcSepCampo + vDescripcion
														+ @vcSepCampo + FORMAT(dFechaRegistro, 'dd/MM/yyyy')
														+ @vcSepCampo + CASE WHEN bActivo = '1' THEN 'Activo' ELSE 'Inactivo' END
												FROM Tienda_Categoria (NOLOCK)
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
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'paCategorias_Listar')
BEGIN
	--GRANT EXECUTE ON dbo.paCategorias_Listar TO dbUser;
	PRINT 'SP Create : paCategorias_Listar';
	PRINT '***'
END
GO