USE BD_SISMA
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==========================================================================================================================
-- Proyecto			:	RR.HH Web
-- Fecha Creación	:	
-- Descripcion		:	
-- Orden Servicio	:	--
-- Responsable		:	
-- ==========================================================================================================================
/*

	paGenSelMProceso_ListarPorPeriodoTProceso '2024|2'

*/
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'paGenSelMProceso_ListarPorPeriodoTProceso')
BEGIN
	DROP PROCEDURE paGenSelMProceso_ListarPorPeriodoTProceso
	PRINT 'SP Delete : paGenSelMProceso_ListarPorPeriodoTProceso';
END;
GO
 create Procedure [dbo].[paGenSelMProceso_ListarPorPeriodoTProceso]
(
	  @pvcData VARCHAR(MAX)
)
As
BEGIN
	SET NOCOUNT ON;
	--> Variables de Corte
	DECLARE @sepRegistro VARCHAR(1) = '¬';
	DECLARE @sepCampo	 VARCHAR(1) = '|';
	DECLARE @sepTabla	 VARCHAR(1) = '~';
	DECLARE @sepOpcional VARCHAR(1) = '^';
	--/
	DECLARE @cPeriodo		VARCHAR(6);
	DECLARE @cTipoProceso	VARCHAR(6);
	--|
	DECLARE @Parameters TABLE(Nro INT, Parameter NVARCHAR(MAX));
	INSERT INTO @Parameters (Nro, Parameter) SELECT * FROM dbo.fnSplitStringTable(@pvcData,@sepCampo);
	--|
	SELECT @cPeriodo	 = Parameter FROM @Parameters WHERE Nro = 0;
	SELECT @cTipoProceso = Parameter FROM @Parameters WHERE Nro = 1;
	--|
	DECLARE @Retorno	VARCHAR(MAX);
	DECLARE @Cabecera	VARCHAR(MAX);
	DECLARE @Registros	VARCHAR(MAX);
	DECLARE @Listas		VARCHAR(MAX) = '';
	--|
	SELECT
	ISNULL((SELECT STUFF ((
									SELECT		@sepRegistro + CONVERT(VARCHAR(20),PRO.PK_eProceso)
												+ @sepCampo + CONVERT(VARCHAR(20),LTRIM(RTRIM(TPRO.cAbreviado)))
													+ '  ' + CONVERT(VARCHAR(20),PRO.UK_eAnio)
													+ '-' + LTRIM(RTRIM(PRO.UK_cNumero))
													+ ' ' + 
													+ '( '  + FORMAT(PRO.fFechaInicio,'dd/MM/yyyy')
													+ ' - ' + FORMAT(PRO.fFechaFinal,'dd/MM/yyyy')
													+ ' )'
									FROM		dbo.PerSelMProceso (NOLOCK) PRO
									INNER JOIN  dbo.PerSelTProceso (NOLOCK) TPRO
											ON	PRO.UK_eTProceso = TPRO.PK_eTProceso
									WHERE		PRO.UK_eAnio = CONVERT(INT,@cPeriodo)
									AND			PRO.UK_eTProceso = CONVERT(INT,@cTipoProceso)
									ORDER BY	PRO.PK_eProceso DESC
					FOR XML PATH('')),1,1,'')),'')
	SET NOCOUNT OFF;
END;
GO
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'paGenSelMProceso_ListarPorPeriodoTProceso')
	PRINT 'SP Create : paGenSelMProceso_ListarPorPeriodoTProceso';
	GRANT EXECUTE ON dbo.paGenSelMProceso_ListarPorPeriodoTProceso TO u_sisma;
GO