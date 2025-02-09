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
	SELECT * FROM Ventas_Tarifa;

	EXEC paTarifa_Listar
*/
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'paTarifa_Listar')
BEGIN
	DROP PROCEDURE dbo.paTarifa_Listar
	PRINT '***'
	PRINT 'SP Delete : paTarifa_Listar';
END;
GO
CREATE PROCEDURE dbo.paTarifa_Listar
AS
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
	SET @vcCabecera =  'Id|Codigo|Nombre|Descripcion|Tipo|Fec. Registro|Estado'
	+ @vcSepRegistro + '50|100|200|300|120|100|100' 
	+ @vcSepRegistro + 'String|String|String|String|String|String|String';
	--|
	SET @vcRegistros =  ISNULL((SELECT STUFF ((
												SELECT		@vcSepRegistro + CONVERT(VARCHAR(20), TAR.PK_eTarifa)
															+ @vcSepCampo + TAR.vCodigo
															+ @vcSepCampo + ISNULL(TAR.vNombre,'')
															+ @vcSepCampo + ISNULL(TAR.vDescripcion,'')
															+ @vcSepCampo + TIP.Tarifa
															+ @vcSepCampo + FORMAT(TAR.dFecha, 'dd/MM/yyyy')
															+ @vcSepCampo + CASE WHEN TAR.bActivo = '1' THEN 'Activo' ELSE 'Inactivo' END
												FROM		dbo.Ventas_Tarifa (NOLOCK) AS TAR
												INNER JOIN	( 
																SELECT	 FK_TTarifa = PK_eTabla
																		,Tarifa = vNombre  
																FROM	 dbo.Sistema_Tablas (NOLOCK)
																WHERE	 vGrupo LIKE '%TIP_TAR%' 
																AND		 ISNULL(ePadre,0) <> 0
															) AS TIP
														ON	TAR.FK_TTarifa = TIP.FK_TTarifa
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
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'paTarifa_Listar')
BEGIN
	--GRANT EXECUTE ON dbo.paTarifa_Listar TO dbUser;
	PRINT 'SP Create : paTarifa_Listar';
	PRINT '***'
END
GO