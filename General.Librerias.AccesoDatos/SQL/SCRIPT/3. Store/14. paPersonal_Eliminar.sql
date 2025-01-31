-- =============================================
-- Author:		Daniel Arroyo Alvarado
-- Proyect:		Imtexa
-- Description:	Elimina Persona (Inactiva)
-- =============================================
/*
select * from general_Persona
paPersonal_Eliminar 'DARROYO~16'
*/
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'paPersonal_Eliminar')
BEGIN
	DROP PROCEDURE paPersonal_Eliminar
	PRINT 'DELETE: paPersonal_Eliminar'
END
GO

CREATE PROCEDURE paPersonal_Eliminar
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
	DECLARE @vcMessage		VARCHAR(MAX) = '';
	DECLARE @vcId			VARCHAR(20); 
	---|
	---| Variables de Corte
	DECLARE @vcSepRegistro	VARCHAR(1) = '¬';
	DECLARE @vcSepCampo		VARCHAR(1) = '|';
	DECLARE @vcSepTabla		VARCHAR(1) = '~';
	DECLARE @vcSepOpcional	VARCHAR(1) = '^';
	DECLARE @vcSepValor		VARCHAR(1) = ',';

	BEGIN TRY

	DECLARE @vcUsuario		VARCHAR(MAX);
	DECLARE @vcDatos		VARCHAR(MAX);

	DECLARE @veIdPersona	INT;


	--> Variables Tabla
		DECLARE @vtabResponse TABLE(Reponse NVARCHAR(MAX));
		DECLARE @vtabParameters TABLE(Nro INT, Parameter NVARCHAR(MAX));
		INSERT INTO @vtabParameters (Nro, Parameter) SELECT * FROM dbo.fnSplitStringTable(@pvcData,@vcSepTabla);
		--
		SELECT	@vcUsuario = Parameter FROM @vtabParameters WHERE Nro = 0;
		SELECT	@vcDatos = Parameter FROM @vtabParameters WHERE Nro = 1;
		

		SET @veIdPersona = ISNULL((SELECT LTRIM(RTRIM(Campo1)) FROM dbo.fnSplitStringRows(@vcDatos,@vcSepRegistro,@vcSepCampo)),'');

				UPDATE P
				SET bActivo = '0',
					vUsuarioActualiza	= @vcUsuario,
					dFechaActualiza		= GETDATE()
				FROM General_Persona as P
				INNER JOIN dbo.fnSplitStringRows(@vcDatos,@vcSepRegistro,@vcSepCampo) as T ON
				P.eIdPersona = @veIdPersona

			SET @vcId = @veIdPersona;
			SET @vcMessage = 'OK|Actualización satisfactoria';

		INSERT 
		INTO @vtabResponse
		EXEC dbo.paPersonal_Listar;

		goFINAL:
		SELECT @vcMessage					-- 0. Mensaje
				+ @vcSepTabla + @vcId		-- 1. Datos del registro
				+ @vcSepTabla + Reponse		-- 2. Lista retorno
		FROM @vtabResponse

		END TRY

		BEGIN CATCH
			SELECT 'KO|'+ CONVERT(VARCHAR,ERROR_NUMBER()) + '-' + ERROR_MESSAGE() + @vcSepTabla + @vcId;
		END CATCH
END;