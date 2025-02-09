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
	EXEC dbo.paCategoria_Agregar '1~|demo|demostracion|1'
*/
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'paCategoria_Agregar')
BEGIN
	DROP PROCEDURE dbo.paCategoria_Agregar
	PRINT '***'
	PRINT 'SP Delete : paCategoria_Agregar';
END
GO
CREATE PROCEDURE dbo.paCategoria_Agregar
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
	DECLARE @vcId			VARCHAR(20); 
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
		--|
		--| Validar Data Existente
		--| *********************************************************************************
		--|
		SELECT	@vcNombre = LTRIM(RTRIM(Campo2))
		FROM	dbo.fnSplitStringRows(@vcDatos,@vcSepRegistro,@vcSepCampo);
		--
		IF EXISTS(SELECT eIdCategoria FROM dbo.Almacen_Categoria WHERE vNombre = @vcNombre)
		BEGIN
			INSERT INTO @vtabResponse select '';
			SET @vcMessage = 'KO|El -Nombre- ingresado ya existe.';
			GOTO goFINAL;
		END
		--| *********************************************************************************
		--
		SELECT	@veIdUsuario = eIdUsuario FROM dbo.Seguridad_Usuario (NOLOCK) WHERE eIdPersona = @veIdPersona;
		-- |
		INSERT INTO	dbo.Almacen_Categoria 
					(	
					 vNombre
					,vDescripcion
					,bActivo
					,vUsuarioRegistro
					,dFechaRegistro
					)
		SELECT		 LTRIM(RTRIM(Campo2))
					,LTRIM(RTRIM(Campo3))
					,IIF(LTRIM(RTRIM(Campo4)) = '1',1,0)
					,@veIdUsuario
					,GETDATE()
		FROM		 dbo.fnSplitStringRows(@vcDatos,@vcSepRegistro,@vcSepCampo);
		---
		SET @vcId = CONVERT(VARCHAR(20),@@IDENTITY)
		---
		---------------------------------------
		SET @vcMessage = 'OK|Registro satisfactorio';
		---
		INSERT 
		INTO	@vtabResponse
		EXEC	dbo.paCategoria_Listar;
		---
		goFINAL:
		SELECT	  @vcMessage						--| 0. Mensaje
				+ @vcSepTabla + @vcId	--| 1. Datos del registro
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
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'paCategoria_Agregar')
BEGIN
	--GRANT EXECUTE ON dbo.paCategoria_Agregar TO dbUser;
	PRINT 'SP Create : paCategoria_Agregar';
	PRINT '***'
END
GO