USE BD_SISMA
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==========================================================================================================================
-- Proyecto Sisma
-- Fecha Creación	:	
-- Descripcion		:	
-- Orden Servicio	:	
-- Responsable		:	Guillermo Zambrano 
-- ==========================================================================================================================
/*
	SELECT * FROM PerSelCompetencia
	EXEC [dbo].[paGenSelConvocatorias_ListarPorId]  '2102'
*/
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'paGenSelConvocatorias_ListarPorId')
BEGIN
	DROP PROCEDURE [dbo].[paGenSelConvocatorias_ListarPorId]
	PRINT 'SP Delete : paGenSelConvocatorias_ListarPorId';
END
GO
CREATE PROCEDURE [dbo].[paGenSelConvocatorias_ListarPorId]
(
	  @pvcData VARCHAR(MAX)
)
AS
BEGIN        
	SET NOCOUNT ON;
	SET DATEFORMAT DMY;
	SET ANSI_NULLS OFF;
	------------------//           
	BEGIN TRY
	-->
	--> Variables Tabla
	DECLARE @Retorno TABLE(Nro INT, Tabla NVARCHAR(MAX));

	DECLARE @vcMessage		VARCHAR(MAX) = '';
	--|
	--| Variables de Corte
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
	DECLARE @ePlazaVacante	INT;
	--|
	DECLARE @vtabParameters TABLE(Nro INT, Parameter NVARCHAR(MAX));
	INSERT INTO @vtabParameters (Nro, Parameter) SELECT * FROM dbo.fnSplitStringTable(@pvcData,@vcSepCampo);
	--|
	SELECT @ePlazaVacante = CONVERT(INT,Parameter) FROM @vtabParameters WHERE Nro = 0;

	SET @vcRetorno = ISNULL((SELECT STUFF ((
									
									--> Listado de Convocatorias
									 SELECT			/* 00 */  @vcSepRegistro + CONVERT(VARCHAR(20),@ePlazaVacante)
													/* 01 */ + @vcSepCampo +	CASE C.UK_cPlaza      
																				WHEN '' THEN ISNULL(C.cCargo,'')
																				ELSE RTRIM(C.UK_cPlaza) + ' - ' +  ISNULL((CASE	WHEN i.UK_eTProceso=1 
																															THEN '('+CAST(eNumeroPlazas AS VARCHAR(3)) +') '+ c.cCargo 
																															ELSE c.cCargo 
																													END),'')
																				END
													/* 02 */ + @vcSepCampo + ISNULL(RTRIM(LTRIM(G.cTProcEstado)),'')
													/* 03 */ + @vcSepCampo + ISNULL(RTRIM(LTRIM(C.cArea)),'')
													/* 04 */ + @vcSepCampo + ISNULL(RTRIM(LTRIM(B.cEstablecimiento)) + ' / ' + RTRIM(LTRIM(h.cUbicacion)),'')
													/* 05 */ + @vcSepCampo + FORMAT(f.fFechaInicio,'dd/MM/yyyy')
													/* 06 */ + @vcSepCampo + FORMAT(f.fFechaFinal,'dd/MM/yyyy')
													/* 07 */ + @vcSepCampo + CONVERT(VARCHAR(MAX),RTRIM(LTRIM(REPLACE(cFunciones,'&#x0D',''))))
													/* 08 */ + @vcSepCampo + CONVERT(VARCHAR(MAX),RTRIM(LTRIM(A.cCondiciones)))
													/* 09 */ + @vcSepCampo + ISNULL(CONVERT(VARCHAR(20),A.eExperienciaMin),'')
													/* 10 */ + @vcSepCampo + ISNULL(CASE A.FK_eTNivelEducativo      
																			 WHEN 0 THEN ''      
																			 ELSE E.cTEducacion + ' - ' + D.cTNivelEducativo END
																			 ,'')
													/* 11 */ + @vcSepCampo + CASE ISNULL(lColegiado,'') WHEN '' THEN '-' ELSE IIF(lColegiado=0,'No','Si') END
													/* 12 */ + @vcSepCampo + ISNULL(CONVERT(VARCHAR(20),C.dBasico),'')

													/* 13 */ + @vcSepCampo + CONVERT(VARCHAR(MAX),RTRIM(LTRIM(A.cPerfil))) + ' ' + CONVERT(VARCHAR(MAX),RTRIM(LTRIM(A.cPerfilAdicional)))
													/* 14 */ + @vcSepCampo + ISNULL(RTRIM(LTRIM(cNivel)),'')
													/* 15 */ + @vcSepCampo + ISNULL(RTRIM(LTRIM(A.cPerfilAdicional)),'')
													/* 16 */ + @vcSepCampo + ISNULL(CONVERT(VARCHAR(20),A.eExperienciaEspecifica),'')
													/* 17 */ + @vcSepCampo + ISNULL(CONVERT(VARCHAR(20),A.eExperienciaEspecificaPublica),'')
													
													/* 18 */ + @vcSepCampo + CASE ISNULL(lHabilitacionProfesional,'') WHEN '' THEN '-' ELSE IIF(lHabilitacionProfesional=0,'No','Si') END
													/* 19 */ + @vcSepCampo + ISNULL(RTRIM(LTRIM(A.cEtapa)),'')
													--
													/* 20 */ + @vcSepCampo + ISNULL(CONVERT(VARCHAR(20),I.FK_eTProcEstado),'')
													/* 21 */ + @vcSepCampo + ISNULL(RTRIM(LTRIM(J.cTProcEstado)),'')
													/* 22 */ + @vcSepCampo + ISNULL(CONVERT(VARCHAR(20),A.eNumeroDias),'')
													/* 23 */ + @vcSepCampo + ISNULL(CONVERT(VARCHAR(20),A.ePostulantes),'')
													--
													/* 24 */ + @vcSepCampo + ISNULL(CONVERT(VARCHAR(20),A.PK_ePlazaVacante),'')
													

								   FROM				dbo.PerSelCPlazaVacante AS A      
								   INNER JOIN		dbo.PlaOrgMEstablecimiento AS B 
											ON		A.FK_eEstablecimiento = B.PK_eEstablecimiento      
								   INNER JOIN		dbo.PlaPre_vw_DatosPlazaCAP AS C 
											ON		A.UK_ePlazaCAP = C.PK_ePlazaCAP      
								   INNER JOIN		dbo.PerLegTNivelEducativo AS D 
											ON		A.FK_eTNivelEducativo = D.PK_eTNivelEducativo      
								   INNER JOIN		dbo.PerLegTEducacion AS E 
											ON		D.FK_eTEducacion = E.PK_eTEducacion      
								   INNER JOIN		dbo.PerSelDProcEtapa as F 
											ON		A.PK_ePlazaVacante = f.FK_ePlazaVacante       
								   INNER JOIN		dbo.PerSelTProcesoEst as G 
											ON		A.FK_eTProcEstado = G.PK_eTProcEstado      
								   INNER JOIN		dbo.PerAsiMUbicacion as H 
											ON		a.FK_eUbicacionTrabajo = h.PK_eUbicacion      
								   INNER JOIN		dbo.PerSelMProceso AS I  
											ON		i.PK_eProceso = a.UK_eProceso     
								   INNER JOIN		dbo.PerSelTProcesoEst as J 
											ON		J.PK_eTProcEstado  = I.FK_eTProcEstado     
								   WHERE			f.lInscripcion = 1 
								   AND				PK_ePlazaVacante =@ePlazaVacante

				FOR XML PATH(''), TYPE).value('(./text())[1]', 'nvarchar(max)'),1,1, '')),'')
	--|
	SELECT @vcRetorno;

	END TRY
	BEGIN CATCH
		EXEC dbo.paGenSegHError_Add;
	END CATCH
	------------------//
	SET NOCOUNT OFF;
END
go
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'paGenSelConvocatorias_ListarPorId')
BEGIN
	PRINT 'SP Create : paGenSelConvocatorias_ListarPorId';
	GRANT EXECUTE ON dbo.paGenSelConvocatorias_ListarPorId TO u_sisma;
END
GO