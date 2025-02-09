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
	SELECT * FROM Almacen_Categoria;

	EXEC paCategoria_Listar
*/
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'paCategoria_Listar')
BEGIN
	DROP PROCEDURE dbo.paCategoria_Listar
	PRINT '***'
	PRINT 'SP Delete : paCategoria_Listar';
END;
GO
CREATE Procedure dbo.paCategoria_Listar
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
	SET @vcCabecera =  'Id|Codigo|Alias|Nombre|Descripcion|Fec. Registro|Estado'
	+ @vcSepRegistro + '50|100|100|200|300|100|100' 
	+ @vcSepRegistro + 'String|String|String|String|String|String|String';
	--|
	SET @vcRegistros =  ISNULL((SELECT STUFF ((
												SELECT	@vcSepRegistro + CONVERT(VARCHAR(20), PK_eCategoria)
														+ @vcSepCampo + vCodigo
														+ @vcSepCampo + ISNULL(vAlias,'')
														+ @vcSepCampo + ISNULL(vNombre,'')
														+ @vcSepCampo + ISNULL(vDescripcion,'')
														+ @vcSepCampo + FORMAT(dFecha, 'dd/MM/yyyy')
														+ @vcSepCampo + CASE WHEN bActivo = '1' THEN 'Activo' ELSE 'Inactivo' END
												FROM	dbo.Almacen_Categoria (NOLOCK)
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
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'paCategoria_Listar')
BEGIN
	--GRANT EXECUTE ON dbo.paCategoria_Listar TO dbUser;
	PRINT 'SP Create : paCategoria_Listar';
	PRINT '***'
END
GO