--USE PROVIASNAC
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
	EXEC dbo.paCategorias_Importar '00905~Version|Anio|Mes|Dia|TipoDia|Sector|Compensable|Recurrente|Descripcion~30|2024|11|14|NL|GEN|1|0|Dia no laborable para el sector público y privado¬30|2024|11|15|NL|GEN|1|0|Dia no laborable para el sector público y privado¬30|2024|11|16|NL|GEN|1|0|Dia no laborable para el sector público y privado¬30|2024|12|6|NL|PUB|1|0|Dia no laborable para el sector público¬30|2024|12|8|FER|GEN|0|1|Inmaculada Concepción¬30|2024|12|9|FER|GEN|0|1|Batalla de Ayacucho¬30|2024|12|23|NL|PUB|1|1|Dia no laborable para el sector público¬30|2024|12|24|NL|PUB|1|1|Dia no laborable para el sector público¬30|2024|12|25|FER|GEN|0|1|Navidad¬30|2024|12|30|NL|PUB|1|1|Dia no laborable para el sector público¬30|2024|12|31|NL|PUB|1|1|Dia no laborable para el sector público¬'
*/
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'paCategorias_Importar')
BEGIN
	DROP PROCEDURE dbo.paCategorias_Importar
	PRINT '***'
	PRINT 'SP Delete : paCategorias_Importar';
END
GO
CREATE PROCEDURE dbo.paCategorias_Importar
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
	DECLARE @veIdPersona	INT;
	DECLARE @vcCabecera		VARCHAR(MAX);
	DECLARE @vcDatos		VARCHAR(MAX);
	---|
	DECLARE @vcId			VARCHAR(MAX);
	DECLARE @veIdUsuario	INT;
	---|
	BEGIN TRY
		---|
		--> Variables Tabla
		DECLARE @vtabResponse TABLE(Reponse NVARCHAR(MAX));
		DECLARE @vtabParameters TABLE(Nro INT, Parameter NVARCHAR(MAX));
		INSERT INTO @vtabParameters (Nro, Parameter) SELECT * FROM dbo.fnSplitStringTable(@pvcData,@vcSepTabla);
		--
		SELECT	@veIdPersona = CONVERT(INT,Parameter) FROM @vtabParameters WHERE Nro = 0;
		SELECT	@vcCabecera = Parameter FROM @vtabParameters WHERE Nro = 1;
		SELECT	@vcDatos = Parameter FROM @vtabParameters WHERE Nro = 2;
		--
		--| *********************************************************************************
		--
		SELECT	@veIdUsuario = eIdUsuario FROM Seguridad_Usuario (NOLOCK) WHERE eIdPersona = @veIdPersona;
		--
		INSERT INTO	dbo.Tienda_Categoria 
					(	
					 vNombre
					,vDescripcion
					,bActivo
					,vUsuarioRegistro
					,dFechaRegistro
					)
		SELECT		 LTRIM(RTRIM(Campo1))
					,LTRIM(RTRIM(Campo2))
					,IIF(LTRIM(RTRIM(Campo3)) = '1',1,0)
					,@veIdUsuario
					,GETDATE()
		FROM		 dbo.fnSplitStringRows(@vcDatos,@vcSepRegistro,@vcSepCampo)
		WHERE		RTRIM(LTRIM(Campo1)) <> '';
		---------------------------------------
		SET @vcId = CONVERT(VARCHAR(20),@@IDENTITY);
		SET @vcMessage = 'OK|Importación satisfactoria';
		---
		INSERT 
		INTO	@vtabResponse
		EXEC	dbo.paCategorias_Listar;
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
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'paCategorias_Importar')
BEGIN
	--GRANT EXECUTE ON dbo.paCategorias_Importar TO dbUser;
	PRINT 'SP Create : paCategorias_Importar';
	PRINT '***'
END
GO