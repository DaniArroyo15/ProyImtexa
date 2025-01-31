USE PROVIASNAC
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==========================================================================================================================|
-- Proyecto			:	RRHH Web
-- Fecha Creación	:	
-- Descripcion		:	
-- Orden Servicio	:	
-- Responsable		:	Guillermo Zambrano
-- ==========================================================================================================================|
/*
	EXEC [dbo].[paCategorias_Eliminar] '00905~7'
*/
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'paCategorias_Eliminar')
BEGIN
	DROP PROCEDURE [dbo].[paCategorias_Eliminar]
	PRINT 'SP Delete : paCategorias_Eliminar';
END
GO
CREATE PROCEDURE [dbo].[paCategorias_Eliminar]
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
	DECLARE @vcIdTipoPapeleta VARCHAR(10) = '';
	------------------//           
	BEGIN TRY
		---|
		---| Variables de Identificacion
		DECLARE @vcIdPeriodo	VARCHAR(4) = '';
		DECLARE @vcMes			VARCHAR(2) = '';
		DECLARE @vcIdPersona	VARCHAR(6) = '';
		DECLARE @vcIdUsuario	VARCHAR(4);
		-->
		--> Variables Tabla
		DECLARE @vtabResponse TABLE(Reponse VARCHAR(MAX));
		DECLARE @vtabParameters TABLE(Nro INT, Parameter VARCHAR(MAX));
		INSERT INTO @vtabParameters (Nro, Parameter) SELECT * FROM dbo.fnSplitStringTable(@pvcData,@vcSepTabla);
		--
		SELECT  @vcIdPersona = Parameter FROM @vtabParameters WHERE Nro = 0;
		SELECT  @vcDatos = Parameter FROM @vtabParameters WHERE Nro = 1;
		---|
		SELECT	@vcIdUsuario = id_usertk FROM dbo.asm11000 (NOLOCK) WHERE id_personal = @vcIdPersona;
		---|
		SELECT	@vcIdTipoPapeleta = LTRIM(RTRIM(Campo1))
		FROM	dbo.fnSplitStringRows(@vcDatos,@vcSepRegistro,@vcSepCampo);
		----|
		UPDATE	 TPAP
		SET		 TPAP.cEstado = 'DEL'
				,TPAP.cLogDelete = '{Usuario: "' + @vcIdUsuario + '", Fecha: "' + CONVERT(VARCHAR(20),GETDATE(),103) + ' ' + CONVERT(VARCHAR(20),GETDATE(),108) + '}'
		FROM	 dbo.PerPapMTipoPapeleta AS TPAP
		WHERE	 TPAP.PK_eTipoPapeleta = CONVERT(INT,@vcIdTipoPapeleta);
		---
		UPDATE		 TPAP
		SET			 TPAP.st_anulado = 1
		FROM		 dbo.rhm37000 AS TPAP
		INNER JOIN	 dbo.PerPapMTipoPapeleta AS WTPAP
				ON	 TPAP.id_ocurrencia = WTPAP.cTipoSigaNet
		WHERE		 WTPAP.PK_eTipoPapeleta = CONVERT(INT,@vcIdTipoPapeleta);
		---
		SET @vcMessage = 'OK|Eliminación satisfactoria';
		---
		DECLARE @ExecParameter VARCHAR(MAX) = @vcIdPeriodo + '|' + @vcMes + '|' + @vcIdPersona;
		---
		INSERT 
		INTO	@vtabResponse
		EXEC	dbo.paPerPapMTipoPapeleta_Listar;
		---
		SELECT	  @vcMessage						--| 0. Mensaje
				+ @vcSepTabla + @vcIdTipoPapeleta	--| 1. Datos del registro
				+ @vcSepTabla + Reponse				--| 2. Listado de Retorno
		FROM	  @vtabResponse;
		---
	END TRY
	BEGIN CATCH
		SELECT 'KO|' + CONVERT(VARCHAR,ERROR_NUMBER()) + '-' + ERROR_MESSAGE() + @vcSepTabla + @vcIdTipoPapeleta;
	END CATCH
	------------------//
	SET NOCOUNT OFF;
END;
GO
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'paCategorias_Eliminar')
BEGIN
	GRANT EXECUTE ON dbo.paCategorias_Eliminar TO dbUser;
	PRINT 'SP Create : paCategorias_Eliminar';
	PRINT '***'
END
GO