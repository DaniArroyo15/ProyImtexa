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

	paGenSelMPlaza_ListarPorNroProceso '2100'

*/
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'paGenSelMPlaza_ListarPorNroProceso')
BEGIN
	DROP PROCEDURE paGenSelMPlaza_ListarPorNroProceso
	PRINT 'SP Delete : paGenSelMPlaza_ListarPorNroProceso';
END;
GO
 create Procedure [dbo].[paGenSelMPlaza_ListarPorNroProceso]
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
	DECLARE @cIdProceso	VARCHAR(6);
	--|
	DECLARE @Parameters TABLE(Nro INT, Parameter NVARCHAR(MAX));
	INSERT INTO @Parameters (Nro, Parameter) SELECT * FROM dbo.fnSplitStringTable(@pvcData,@sepCampo);
	--|
	SELECT @cIdProceso	 = Parameter FROM @Parameters WHERE Nro = 0;
	--|
	DECLARE @Retorno	VARCHAR(MAX);
	DECLARE @Cabecera	VARCHAR(MAX);
	DECLARE @Registros	VARCHAR(MAX);
	DECLARE @Listas		VARCHAR(MAX) = '';
	--|
	SELECT
	ISNULL((SELECT STUFF ((
									SELECT		@sepRegistro + CONVERT(VARCHAR(20),PLA.PK_ePlazaVacante)
												+ @sepCampo + ISNULL(UPPER(RTRIM(LTRIM(CAR.cCargo))),'')
									FROM		dbo.PlaOrgTCargo (NOLOCK) CAR
									INNER JOIN  dbo.PlaOrgDPlazaCAP (NOLOCK) CAP
											ON	CAR.PK_eTCargo = CAP.FK_eTCargo
									INNER JOIN  dbo.PerSelCPlazaVacante (NOLOCK) PLA
											ON	CAP.PK_ePlazaCAP = PLA.UK_ePlazaCAP
									WHERE		PLA.UK_eProceso = CONVERT(INT,@cIdProceso)
									ORDER BY	PLA.UK_eProceso DESC
					FOR XML PATH('')),1,1,'')),'')

	/*
	Select * from [PlaOrgTCargo] where PK_eTCargo = 2970
	select * from PlaOrgDPlazaCAP WHERE PK_ePlazaCAP = 10451
	select * from PerSelCPlazaVacante where UK_eProceso =  2100
	SELECT * FROM PerSelMProceso WHERE UK_eAnio = 2024 AND UK_eTProceso = 2
	*/
	SET NOCOUNT OFF;
END;
GO
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'paGenSelMPlaza_ListarPorNroProceso')
	PRINT 'SP Create : paGenSelMPlaza_ListarPorNroProceso';
	GRANT EXECUTE ON dbo.paGenSelMPlaza_ListarPorNroProceso TO u_sisma;
GO