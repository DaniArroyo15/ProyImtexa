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

	paGenSelMEtapa_ListarPorNroPlaza '2100'

*/
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'paGenSelMEtapa_ListarPorNroPlaza')
BEGIN
	DROP PROCEDURE paGenSelMEtapa_ListarPorNroPlaza
	PRINT 'SP Delete : paGenSelMEtapa_ListarPorNroPlaza';
END;
GO
 create Procedure [dbo].[paGenSelMEtapa_ListarPorNroPlaza]
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
	DECLARE @cIdPlaza	VARCHAR(10);
	--|
	DECLARE @Parameters TABLE(Nro INT, Parameter NVARCHAR(MAX));
	INSERT INTO @Parameters (Nro, Parameter) SELECT * FROM dbo.fnSplitStringTable(@pvcData,@sepCampo);
	--|
	SELECT @cIdPlaza = Parameter FROM @Parameters WHERE Nro = 0;
	--|
	DECLARE @Retorno	VARCHAR(MAX);
	DECLARE @Cabecera	VARCHAR(MAX);
	DECLARE @Registros	VARCHAR(MAX);
	DECLARE @Listas		VARCHAR(MAX) = '';
	--|
	SELECT
	ISNULL((SELECT STUFF ((
							SELECT		@sepRegistro + CONVERT(VARCHAR(20),PK_eProcEtapa)
										--+ @sepCampo + CONVERT(CHAR(30),ISNULL(UPPER(RTRIM(LTRIM(cEtapa))),''))
										+ @sepCampo + ISNULL(UPPER(RTRIM(LTRIM(cEtapa))),'')
										+ ' ( ' + FORMAT(fFechaInicio,'dd/MM/yyyy')
										+ ' - ' + FORMAT(fFechaFinal,'dd/MM/yyyy')
										+ ' ) '
							FROM		dbo.PerSelDProcEtapa (NOLOCK)
							WHERE		FK_ePlazaVacante = CONVERT(INT,@cIdPlaza)
							ORDER BY	eOrden ASC
			FOR XML PATH('')),1,1,'')),'')
	SET NOCOUNT OFF;
	SELECT * FROM PerSelDProcEtapa WHERE FK_ePlazaVacante = 2100
END;
GO
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'paGenSelMEtapa_ListarPorNroPlaza')
	PRINT 'SP Create : paGenSelMEtapa_ListarPorNroPlaza';
	GRANT EXECUTE ON dbo.paGenSelMEtapa_ListarPorNroPlaza TO u_sisma;
GO