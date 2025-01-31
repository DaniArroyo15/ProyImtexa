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
	EXEC [dbo].[paGenSelConvocatorias_Listar]  '2024||'
*/
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'paGenSelConvocatorias_Listar')
BEGIN
	DROP PROCEDURE [dbo].[paGenSelConvocatorias_Listar]
	PRINT 'SP Delete : paGenSelConvocatorias_Listar';
END
GO
CREATE PROCEDURE [dbo].[paGenSelConvocatorias_Listar]
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
	DECLARE @sPeriodo		INT;
	DECLARE @sTipo			VARCHAR(20);
	DECLARE @sEstado		VARCHAR(20);
	--|
	DECLARE @vtabParameters TABLE(Nro INT, Parameter NVARCHAR(MAX));
	INSERT INTO @vtabParameters (Nro, Parameter) SELECT * FROM dbo.fnSplitStringTable(@pvcData,@vcSepCampo);
	--|
	SELECT @sPeriodo = CONVERT(INT,Parameter) FROM @vtabParameters WHERE Nro = 0;
	SELECT @sTipo = Parameter FROM @vtabParameters WHERE Nro = 1;
	SELECT @sEstado = Parameter FROM @vtabParameters WHERE Nro = 2;
	--|
	SET @vcCabecera  = 'Id|N° Proceso|Cargo|Establecimiento|Postulantes|Etapa|Inscripción|Cierre|Días|Estado|ePlazaVacante'
	+ @vcSepRegistro + '0|80|310|250|20|130|60|60|10|60|0' 
	+ @vcSepRegistro + 'String|String|String|String|String|String|String|String|String|String|String'

	SET @vcRegistros = ISNULL((SELECT STUFF ((
			--> Listado de Convocatorias
			SELECT		/* 00 */ @vcSepRegistro + CONVERT(VARCHAR(20),A.PK_eProceso)
						/* 01 */ + @vcSepCampo + IIF(ISNULL(G.cAbreviado,'') = '','',RTRIM(G.cAbreviado) + ' - ') + A.UK_cNumero + ' - ' + CONVERT(VARCHAR(10),A.UK_eAnio)
						/* 02 */ + @vcSepCampo + ISNULL(IIF(A.UK_eTProceso=1,'(' + CONVERT(VARCHAR(10),eNumeroPlazas) + ') ','') + C.cCargo,'')
						/* 03 */ + @vcSepCampo + ISNULL(LTRIM(RTRIM(D.cEstablecimiento)),'')
						/* 04 */ + @vcSepCampo + ISNULL(CONVERT(VARCHAR(20),A.ePostulantes),'')
						/* 05 */ + @vcSepCampo + ISNULL(LTRIM(RTRIM(B.cEtapa)),'')
						/* 06 */ + @vcSepCampo + CONVERT(VARCHAR(20),E.fFechaInicio,103)
						/* 07 */ + @vcSepCampo + CONVERT(VARCHAR(20),E.fFechaFinal,103)
						/* 08 */ + @vcSepCampo + ISNULL(CONVERT(VARCHAR(20),A.eNumeroDias),'')
						/* 09 */ + @vcSepCampo + RTRIM(LTRIM(F.cTProcEstado))
						/* 10 */ + @vcSepCampo + ISNULL(CONVERT(VARCHAR(20),B.PK_ePlazaVacante),'')
			FROM		dbo.PerSelMProceso (NOLOCK) AS A             
			INNER JOIN	dbo.PerSelCPlazaVacante (NOLOCK) AS B ON A.PK_eProceso = B.UK_eProceso             
			INNER JOIN	dbo.PlaPre_vw_DatosPlazaCAP (NOLOCK) AS C ON B.UK_ePlazaCAP = C.PK_ePlazaCAP             
			INNER JOIN	dbo.PlaOrgMEstablecimiento (NOLOCK) AS D ON B.FK_eEstablecimiento = D.PK_eEstablecimiento               
			INNER JOIN	dbo.PerSelTProcesoEst (NOLOCK) AS F ON B.FK_eTProcEstado = F.PK_eTProcEstado            
			INNER JOIN	dbo.PerSelTProceso (NOLOCK) AS G ON	A.UK_eTProceso = G.PK_eTProceso            
			INNER JOIN	(            
							SELECT	 FK_ePlazaVacante
									,MIN(fFechaInicio) fFechaInicio
									,MAX(fFechaFinal) fFechaFinal             
							FROM		 dbo.PerSelDProcEtapa (NOLOCK)
							GROUP BY  FK_ePlazaVacante            
						 ) AS E ON b.PK_ePlazaVacante = e.FK_ePlazaVacante
			WHERE		 A.UK_eAnio = CASE LEN(@sPeriodo) WHEN 0 THEN A.UK_eAnio ELSE @sPeriodo END
			AND			 A.UK_eTProceso = CASE LEN(@sTipo) WHEN 0 THEN A.UK_eTProceso ELSE @sTipo END 
			AND			 B.FK_eTProcEstado = CASE LEN(@sEstado) WHEN 0 THEN B.FK_eTProcEstado ELSE @sEstado END
			ORDER BY	 A.UK_cNumero DESC
						,C.cCargo DESC
	FOR XML PATH('')),1,1,'')),'')
	--|
	SET @vcRetorno =	CASE 
					WHEN @vcRegistros = '' 
					THEN @vcCabecera 
					ELSE @vcCabecera + @vcSepRegistro + @vcRegistros 
					END
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
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'paGenSelConvocatorias_Listar')
BEGIN
	PRINT 'SP Create : paGenSelConvocatorias_Listar';
	GRANT EXECUTE ON dbo.paGenSelConvocatorias_Listar TO u_sisma;
END
GO