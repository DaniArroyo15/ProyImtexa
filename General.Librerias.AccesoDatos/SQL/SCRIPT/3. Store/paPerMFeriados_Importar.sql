USE PROVIASNAC
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==========================================================================================================================|
-- Proyecto			: RRHH Web
-- Fecha Creación	:	
-- Descripcion		:	
-- Orden Servicio	:	
-- Responsable		: Guillermo Zambrano
-- ==========================================================================================================================|
/*
	SELECT * FROM PerMDiasNoLaborables
*/
-- ==========================================================================================================================|
/*
	EXEC [dbo].[paPerMFeriados_Importar] '00905~Version|Anio|Mes|Dia|TipoDia|Sector|Compensable|Recurrente|Descripcion~30|2024|11|14|NL|GEN|1|0|Dia no laborable para el sector público y privado¬30|2024|11|15|NL|GEN|1|0|Dia no laborable para el sector público y privado¬30|2024|11|16|NL|GEN|1|0|Dia no laborable para el sector público y privado¬30|2024|12|6|NL|PUB|1|0|Dia no laborable para el sector público¬30|2024|12|8|FER|GEN|0|1|Inmaculada Concepción¬30|2024|12|9|FER|GEN|0|1|Batalla de Ayacucho¬30|2024|12|23|NL|PUB|1|1|Dia no laborable para el sector público¬30|2024|12|24|NL|PUB|1|1|Dia no laborable para el sector público¬30|2024|12|25|FER|GEN|0|1|Navidad¬30|2024|12|30|NL|PUB|1|1|Dia no laborable para el sector público¬30|2024|12|31|NL|PUB|1|1|Dia no laborable para el sector público¬'
*/
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'paPerMFeriados_Importar')
BEGIN
	DROP PROCEDURE [dbo].[paPerMFeriados_Importar]
	PRINT 'SP Delete : paPerMFeriados_Importar';
END
GO
CREATE PROCEDURE [dbo].[paPerMFeriados_Importar]
(
	@pvcData VARCHAR(MAX)
)
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
	---|
	---| Variables de Entrada
	DECLARE @vcIdPersona	VARCHAR(6) = '';
	DECLARE @vcCabecera		VARCHAR(MAX);
	DECLARE @vcDatos		VARCHAR(MAX);
	---|
	DECLARE @vcId			VARCHAR(MAX);
	DECLARE @vcIdUsuario	VARCHAR(4);
	---|
	BEGIN TRY
		---|
		---| Variables de Identificacion
		-->
		--> Variables Tabla
		DECLARE @vtabResponse TABLE(Reponse NVARCHAR(MAX));
		DECLARE @vtabParameters TABLE(Nro INT, Parameter NVARCHAR(MAX));
		INSERT INTO @vtabParameters (Nro, Parameter) SELECT * FROM dbo.fnSplitStringTable(@pvcData,@vcSepTabla);
		--
		SELECT	@vcIdPersona = Parameter FROM @vtabParameters WHERE Nro = 0;
		SELECT	@vcCabecera = Parameter FROM @vtabParameters WHERE Nro = 1;
		SELECT	@vcDatos = Parameter FROM @vtabParameters WHERE Nro = 2;
		--
		--| *********************************************************************************
		--
		SELECT	@vcIdUsuario = id_usertk FROM dbo.asm11000 (NOLOCK) WHERE id_personal = @vcIdPersona;
		--
		INSERT 
		INTO	dbo.PerMDiasNoLaborables
				(	
					 eVersion
					,eAnio
					,eMes
					,eDia
					,cTipoDia
					,cSector
					,lCompensable
					,lRecurrente
					,cDescripción
					,cUsuarioRegistro
				)
		SELECT		 CONVERT(INT,LTRIM(RTRIM(Campo1)))
					,CONVERT(INT,LTRIM(RTRIM(Campo2)))
					,CONVERT(INT,LTRIM(RTRIM(Campo3)))
					,CONVERT(INT,LTRIM(RTRIM(Campo4)))
					,UPPER(LTRIM(RTRIM(Campo5)))
					,UPPER(LTRIM(RTRIM(Campo6)))
					,CONVERT(BIT,LTRIM(RTRIM(Campo7)))
					,CONVERT(BIT,LTRIM(RTRIM(Campo8)))
					,UPPER(LTRIM(RTRIM(Campo9)))
					,@vcIdUsuario
		FROM		 dbo.fnSplitStringRows(@vcDatos,@vcSepRegistro,@vcSepCampo)
		WHERE		RTRIM(LTRIM(Campo1)) <> '';
		---------------------------------------
		SET @vcId = CONVERT(VARCHAR(20),@@IDENTITY);
		SET @vcMessage = 'OK|Importación satisfactoria';
		---
		INSERT 
		INTO	@vtabResponse
		EXEC	dbo.paPerMFeriados_Listar;
		---
		goFINAL:
		SELECT	  @vcMessage						--| 0. Mensaje
				+ @vcSepTabla + @vcId				--| 1. Datos del registro
				+ @vcSepTabla + Reponse				--| 2. Listado de Retorno
		FROM	  @vtabResponse;
		---
	END TRY
	BEGIN CATCH
		SELECT 'KO|' + CONVERT(VARCHAR,ERROR_NUMBER()) + '-' + ERROR_MESSAGE() + @vcSepTabla + @vcId;
	END CATCH
	------------------//
	SET NOCOUNT OFF;
END;
GO
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'paPerMFeriados_Importar')
BEGIN
	GRANT EXECUTE ON dbo.paPerMFeriados_Importar TO dbUser;
	PRINT 'SP Create : paPerMFeriados_Importar';
	PRINT '***'
END
GO