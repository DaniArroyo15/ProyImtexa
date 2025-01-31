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
	EXEC [dbo].[paGenSelPostEtapa_ListPostulantes]  19225
*/
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'paGenSelPostEtapa_ListPostulantes')
BEGIN
	DROP PROCEDURE [dbo].[paGenSelPostEtapa_ListPostulantes]
	PRINT 'SP Delete : paGenSelPostEtapa_ListPostulantes';
END
GO
CREATE PROCEDURE [dbo].[paGenSelPostEtapa_ListPostulantes]
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
	DECLARE @pFK_eProcEtapa	INT;
	--|
	DECLARE @vtabParameters TABLE(Nro INT, Parameter NVARCHAR(MAX));
	INSERT INTO @vtabParameters (Nro, Parameter) SELECT * FROM dbo.fnSplitStringTable(@pvcData,@vcSepCampo);
	--|
	SELECT @pFK_eProcEtapa = CONVERT(INT,LTRIM(RTRIM(@pvcData)));
	--|
	SET @vcCabecera  = 'PK_ePostulante|Codigo|Nro Docunento|cFullName|Estado|Observaciones'
	+ @vcSepRegistro + '0|90|200|300|80|200' 
	+ @vcSepRegistro + 'String|String|String|String|String|String|String'


	DECLARE  @vePlazaVacante      INT
			,@cEtapa              VARCHAR(50)
			,@fFechaEvaluacion    DATE
			,@tHoraEvaluacion     TIME

	--> Obtiene la plaza y etapa actual  
	SELECT	 @vePlazaVacante = FK_ePlazaVacante
			,@cEtapa = case when cEtapa='EVALUACIÓN DE CONOCIMIENTOS' then 'EVALUACION TECNICA ESCRITA' else cEtapa end  
	FROM     PerSelDProcEtapa  (NOLOCK)  
	WHERE    PK_eProcEtapa = @pFK_eProcEtapa  

	--> Obtiene la fecha y hora de evaluación según la etapa  
	IF @cEtapa = 'EVALUACION HOJA DE VIDA' OR @cEtapa = 'EVALUACIÓN DE LA HOJA DE VIDA'    
	BEGIN  
		SELECT	 @fFechaEvaluacion = fFechaEvaluacion
				,@tHoraEvaluacion = tHoraEvaluacion  
		FROM	 PerSelDProcEtapa  (NOLOCK)  
		WHERE	 FK_ePlazaVacante = @vePlazaVacante  
		AND		cEtapa = 'EVALUACION TECNICA ESCRITA' OR cEtapa = 'EVALUACIÓN DE CONOCIMIENTOS'  

	END

	IF @cEtapa = 'EVALUACION TECNICA ESCRITA' OR @cEtapa = 'EVALUACIÓN DE CONOCIMIENTOS'
	BEGIN
		SELECT	 @fFechaEvaluacion = fFechaEvaluacion
				,@tHoraEvaluacion = tHoraEvaluacion
		FROM	 PerSelDProcEtapa  (NOLOCK)
		WHERE	 FK_ePlazaVacante = @vePlazaVacante
		AND		 cEtapa = 'EVALUACION CURRICULAR' 
	END

	IF @cEtapa = 'EVALUACION CURRICULAR'
	BEGIN
		SELECT	 @fFechaEvaluacion = fFechaEvaluacion
				,@tHoraEvaluacion = tHoraEvaluacion
		FROM	 PerSelDProcEtapa  (NOLOCK)
		WHERE	 FK_ePlazaVacante = @vePlazaVacante
		AND		 cEtapa = 'ENTREVISTA PERSONAL'
	END

	--> MGZP : Obtengo la Nota Minima
	DECLARE  @NotaMin DECIMAL(5,2) = 0;
	DECLARE  @IsActiveTop5 INT = 0;
	--
	SELECT	 @IsActiveTop5 = PK_eProcEtapa
			,@NotaMin = dNotaMinima 
	FROM	 dbo.PerSelDProcNotas (NOLOCK) 
	WHERE	 PK_eProcEtapa = @pFK_eProcEtapa;


	SET @vcRegistros = ISNULL((SELECT STUFF ((
					
	--> Listado de Postulantes  
	SELECT	 @vcSepRegistro + CONVERT(VARCHAR,A.PK_ePostulante)
			+ @vcSepCampo + CONVERT(VARCHAR,A.PK_ePersona)
			--+ @vcSepCampo + CONVERT(VARCHAR,A.FK_eTEstadoPos)
			+ @vcSepCampo + CONVERT(VARCHAR,A.cNumeroDoc)
			+ @vcSepCampo + CONVERT(VARCHAR,A.cFullName)
			+ @vcSepCampo + CONVERT(VARCHAR,A.cEstadoPos)
			+ @vcSepCampo + CONVERT(VARCHAR,A.cObservacionesEspecialista)
			/*
			+ @vcSepCampo + CONVERT(VARCHAR,A.dPerfilCargo)
			+ @vcSepCampo + CONVERT(VARCHAR,A.dExperienciaMinima)
			+ @vcSepCampo + CONVERT(VARCHAR,A.dExperienciaLaboral)
			+ @vcSepCampo + CONVERT(VARCHAR,A.dEduPrincipal)
			+ @vcSepCampo + CONVERT(VARCHAR,A.dEduComplementaria)
			+ @vcSepCampo + CONVERT(VARCHAR,A.dSubTotal)
			+ @vcSepCampo + CONVERT(VARCHAR,ISNULL(D.dTotal,0))
			+ @vcSepCampo + CONVERT(VARCHAR,A.lApto)
			+ @vcSepCampo + CONVERT(VARCHAR,A.lRevisarDJ)
			+ @vcSepCampo + CONVERT(VARCHAR,A.dPuntajeFinal)
			+ @vcSepCampo + CONVERT(VARCHAR,ISNULL(A.cObservaciones,'') + (CASE WHEN A.dSubTotal >= @NotaMin THEN '' ELSE '~' END))
			+ @vcSepCampo + CONVERT(VARCHAR,A.lDescalificacionForzada)
			+ @vcSepCampo + CONVERT(VARCHAR,dbo.fxPerLegMPersona_GetRegistroDeMerito(A.PK_ePersona))
			+ @vcSepCampo + CONVERT(VARCHAR,ISNULL(E.dTotalTecnicaEscrita,0))
			+ @vcSepCampo + CONVERT(VARCHAR,ISNULL(B.dTotalCurricular,0))
			+ @vcSepCampo + CONVERT(VARCHAR,ISNULL(C.dTotalEntrevista,0))
			
			+ @vcSepCampo + CONVERT(VARCHAR,A.dCONADIS)
			+ @vcSepCampo + CONVERT(VARCHAR,A.dFFAA)
			+ @vcSepCampo + CONVERT(VARCHAR,(CASE WHEN A.FK_eTEstadoPos = 5 THEN @fFechaEvaluacion ELSE NULL END))
			+ @vcSepCampo + CONVERT(VARCHAR,(CASE WHEN A.FK_eTEstadoPos = 5 THEN ISNULL(A.tHoraEvaluacion,@tHoraEvaluacion) ELSE NULL END))
			
			+ @vcSepCampo + CONVERT(VARCHAR,A.lOrden)
			*/
	FROM	 (
				SELECT	* 
				FROM	dbo.PerSel_vw_PostulanteEtapa 
				WHERE	FK_eProcEtapa = @pFK_eProcEtapa 
			) as A  

	--> 6 EVALUACION TECNICA ESCRITA
	LEFT JOIN (
				SELECT		 PER.PK_ePostulante
							,c.dTotal as dTotalTecnicaEscrita
				FROM		 dbo.PerSelMPostulante (NOLOCK) AS PER
				INNER JOIN	 dbo.PerSelCPostEtapa (NOLOCK) AS c
						ON	 PER.PK_ePostulante = c.FK_ePostulante
				INNER JOIN	 PerSelDProcEtapa (NOLOCK) AS d
						ON	 d.PK_eProcEtapa = c.FK_eProcEtapa
				WHERE		 UK_ePlazaVacante = @vePlazaVacante
				AND			 d.FK_eTEvaluacion = 6
				AND			(d.cEtapa = 'EVALUACION TECNICA ESCRITA' OR d.cEtapa = 'EVALUACIÓN DE CONOCIMIENTOS')

				) as E

			ON A.PK_ePostulante = E.PK_ePostulante

	--> 2 EVALUACION CURRICULAR

	LEFT JOIN (

				SELECT		 PER.PK_ePostulante

				,c.dTotal as dTotalCurricular 

				FROM		 dbo.PerSelMPostulante (NOLOCK) AS PER

				INNER JOIN	 dbo.PerSelCPostEtapa (NOLOCK) AS c ON PER.PK_ePostulante = c.FK_ePostulante

				INNER JOIN	 PerSelDProcEtapa (NOLOCK) AS d ON d.PK_eProcEtapa = c.FK_eProcEtapa

				WHERE		 UK_ePlazaVacante = @vePlazaVacante

				AND			 d.FK_eTEvaluacion = 2  

				AND			 d.cEtapa = 'EVALUACION CURRICULAR'

				) as B 

			ON	A.PK_ePostulante = B.PK_ePostulante




	--7 ENTREVISTA PERSONAL

	LEFT JOIN (

	SELECT		 PER.PK_ePostulante

	,c.dTotal as dTotalEntrevista

	FROM		 dbo.PerSelMPostulante (NOLOCK) AS PER

	INNER JOIN   dbo.PerSelCPostEtapa (NOLOCK) AS c 

	ON	 PER.PK_ePostulante = c.FK_ePostulante

	INNER JOIN   PerSelDProcEtapa (NOLOCK) AS d 

	ON	 d.PK_eProcEtapa = c.FK_eProcEtapa

	WHERE		 UK_ePlazaVacante = @vePlazaVacante

	AND			 d.FK_eTEvaluacion = 7

	AND			 d.cEtapa = 'ENTREVISTA PERSONAL'

	) as C 

	ON	A.PK_ePostulante = C.PK_ePostulante

	LEFT JOIN (

	SELECT		 PER.PK_ePostulante

	,SUM(c.dTotal) dTotal

	FROM		 dbo.PerSelMPostulante (NOLOCK) AS PER

	INNER JOIN	 dbo.PerSelCPostEtapa (NOLOCK) AS c 

	ON	 PER.PK_ePostulante = c.FK_ePostulante

	INNER JOIN	 PerSelDProcEtapa (NOLOCK) AS d 

	ON	 d.PK_eProcEtapa = c.FK_eProcEtapa

	WHERE		 UK_ePlazaVacante = @vePlazaVacante

	GROUP BY	 PER.PK_ePostulante

	) as D 

	ON	A.PK_ePostulante = D.PK_ePostulante

	ORDER BY ISNULL(D.dTotal,0) DESC, A.lOrden,cFullName
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
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'paGenSelPostEtapa_ListPostulantes')
BEGIN
	PRINT 'SP Create : paGenSelPostEtapa_ListPostulantes';
	GRANT EXECUTE ON dbo.paGenSelPostEtapa_ListPostulantes TO u_sisma;
END
GO