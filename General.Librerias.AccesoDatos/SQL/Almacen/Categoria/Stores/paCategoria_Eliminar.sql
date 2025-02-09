--USE PROVIASNAC
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
	EXEC [dbo].[paCategoria_Eliminar] '00905~7'
*/
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'paCategoria_Eliminar')
BEGIN
	DROP PROCEDURE [dbo].[paCategoria_Eliminar]
	PRINT 'SP Delete : paCategoria_Eliminar';
END
GO
CREATE PROCEDURE [dbo].[paCategoria_Eliminar]
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
	DECLARE @vId VARCHAR(10) = '';
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
		SELECT	@vcIdUsuario = eIdUsuario FROM dbo.Seguridad_Usuario (NOLOCK) WHERE eIdPersona = @vcIdPersona;
		---|
		SELECT	@vId = LTRIM(RTRIM(Campo1))
		FROM	dbo.fnSplitStringRows(@vcDatos,@vcSepRegistro,@vcSepCampo);
		----|
		UPDATE	 CAT
		SET		 CAT.vEstado = 'DEL'
				,CAT.vLogDelete = '{Usuario: "' + @vcIdUsuario + '", Fecha: "' + FORMAT(GETDATE(),'dd/MM/yyyy hh:mm:ss') + '}'
		FROM	 dbo.Almacen_Categoria AS CAT
		WHERE	 CAT.PK_eCategoria = CONVERT(INT,@vId);
		---
		SET @vcMessage = 'OK|Eliminación satisfactoria';
		---
		INSERT 
		INTO	@vtabResponse
		EXEC	dbo.paCategoria_Listar;
		---
		SELECT	  @vcMessage				--| 0. Mensaje
				+ @vcSepTabla + @vId		--| 1. Datos del registro
				+ @vcSepTabla + Reponse		--| 2. Listado de Retorno
		FROM	  @vtabResponse;
		---
	END TRY
	BEGIN CATCH
		SELECT 'KO|' + CONVERT(VARCHAR,ERROR_NUMBER()) + '-' + ERROR_MESSAGE() + @vcSepTabla + @vId;
	END CATCH
	------------------//
	SET NOCOUNT OFF;
END;
GO
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'paCategoria_Eliminar')
BEGIN
	--GRANT EXECUTE ON dbo.paCategoria_Eliminar TO dbUser;
	PRINT 'SP Create : paCategoria_Eliminar';
	PRINT '***'
END
GO