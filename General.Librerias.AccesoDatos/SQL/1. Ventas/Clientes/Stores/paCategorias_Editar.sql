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
	EXEC dbo.paCategorias_Editar '00905~00007|PERMISO ESPECIAL - 30 MIN|RIS 34405 - ART. 345|MIN|30|0|0|0|1'
	EXEC dbo.paCategorias_Editar '00905~00014|CITACION JUDICIAL, MILITAR O P|Art. 24 Permiso individual para ausentarse:  e) hasta 1 jornada laboral|DOCUMENTO DE LA CITACIÓN|PRE|MIN|480|1|0|0|0|1'
	EXEC dbo.paCategorias_Editar '00905~00018|PARO/HUELGA - COMPENSABLE|PRE|DIA|2|Art. 24 Permiso individual para ausentarse:  b) sssssssssss|ESTAS HORAS SE COMPENSAN, EN LA PAPELETA DEBE DECIR DESDE QUE FECHA SE COMPENSARAN xxxxxxxxx|0|0|0|1|1|5|3|4'
s*/
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'paCategorias_Editar')
BEGIN
	DROP PROCEDURE dbo.paCategorias_Editar
	PRINT '***'
	PRINT 'SP Delete : paCategorias_Editar';
END
GO
CREATE PROCEDURE dbo.paCategorias_Editar
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
	DECLARE @vcDatos	VARCHAR(MAX);
	DECLARE @vcDetalle	VARCHAR(MAX);
	---|
	DECLARE @veId		INT;
	------------------//           
	BEGIN TRY
		---| Variables de Identificacion
		DECLARE @veIdPersona	VARCHAR(6); 
		DECLARE @veIdUsuario	VARCHAR(4); 
		DECLARE @vcNombre		VARCHAR(250); 
		-->
		--> Variables Tabla
		DECLARE @vtabResponse TABLE(Reponse NVARCHAR(MAX));
		DECLARE @vtabParameters TABLE(Nro INT, Parameter NVARCHAR(MAX));
		INSERT INTO @vtabParameters (Nro, Parameter) SELECT * FROM dbo.fnSplitStringTable(@pvcData,@vcSepTabla);
		--
		SELECT	@veIdPersona = CONVERT(INT,Parameter) FROM @vtabParameters WHERE Nro = 0;
		SELECT	@vcDatos = Parameter FROM @vtabParameters WHERE Nro = 1;
		---|
		SELECT	@veIdUsuario = eIdUsuario FROM Seguridad_Usuario (NOLOCK) WHERE eIdPersona = @veIdPersona;

		SELECT	@veId = CONVERT(INT,LTRIM(RTRIM(Campo1)))
		FROM	dbo.fnSplitStringRows(@vcDatos,@vcSepRegistro,@vcSepCampo);
		--|
		--| Validar Data Existente
		--| *********************************************************************************
		DECLARE @sNombre	VARCHAR(150);
		--|
		SELECT		 @sNombre = LTRIM(RTRIM(Campo2))
		FROM		 dbo.fnSplitStringRows(@vcDatos,@vcSepRegistro,@vcSepCampo);
		--
		IF EXISTS(SELECT eIdCategoria FROM dbo.Tienda_Categoria (NOLOCK) WHERE vNombre = @sNombre AND eIdCategoria <> @veId)
		BEGIN
			INSERT INTO @vtabResponse select '';
			SET @vcMessage = 'KO|El -Nombre- ingresado ya existe.';
			GOTO goFINAL;
		END
		--| *********************************************************************************
		--|
		UPDATE		 CAT
		SET			 CAT.vNombre = LTRIM(RTRIM(Campo2))
					,CAT.vDescripcion = LTRIM(RTRIM(Campo3))
					,CAT.bActivo = IIF(LTRIM(RTRIM(Campo3))='1',1,0)
					,CAT.dFechaActualiza = GETDATE()
					,CAT.vIdPcActualiza = '127.0'
					,CAT.vUsuarioActualiza = @veIdUsuario
		FROM		 dbo.Tienda_Categoria AS CAT
		INNER JOIN	 dbo.fnSplitStringRows(@vcDatos,@vcSepRegistro,@vcSepCampo) AS TMP
				ON	 CAT.eIdCategoria = CONVERT(INT,LTRIM(RTRIM(Campo1)));
		---
		SET @vcMessage = 'OK|Actualización satisfactoria';
		---
		INSERT 
		INTO	@vtabResponse
		EXEC	dbo.paPerPapMTipoPapeleta_Listar;
		---
		goFINAL:
		SELECT	  @vcMessage								--| 0. Mensaje
				+ @vcSepTabla + CONVERT(VARCHAR(20),@veId)	--| 1. Datos del registro
				+ @vcSepTabla + Reponse						--| 2. Listado de Retorno
		FROM	  @vtabResponse;
		---
	END TRY
	BEGIN CATCH
		SELECT 'KO|' + CONVERT(VARCHAR,ERROR_NUMBER()) + '-' + ERROR_MESSAGE() + @vcSepTabla + CONVERT(VARCHAR(20),@veId);
	END CATCH
	------------------//
	SET NOCOUNT OFF;
END;
GO
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'paCategorias_Editar')
BEGIN
	--GRANT EXECUTE ON dbo.paCategorias_Editar TO dbUser;
	PRINT 'SP Create : paCategorias_Editar';
	PRINT '***'
END
GO