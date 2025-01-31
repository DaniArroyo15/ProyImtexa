/*
=============================================
 Author:		Daniel Arroyo Alvarado
 Proyect:		Imtexa
 Description:	Graba Persona
=============================================
paPersonal_Grabar 'DARROYO~2|2|10203044|CHIVO|chato|CHATO|5|999888777|DARROYO@GMAIL.COM|AV SERGIO 897 - surquillo'

select * from General_Persona
*/

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'paPersonal_Grabar')
BEGIN
	DROP PROCEDURE paPersonal_Grabar
	PRINT 'SP DELETE: paPersonal_Grabar'
END
GO

CREATE PROCEDURE paPersonal_Grabar
(
	@pvcData VARCHAR(MAX)
)
AS
BEGIN
	DECLARE @vcSepRegistro varchar(1) = '¬';
	DECLARE @vcSepCampo varchar(1) = '|';
	DECLARE @vcSepTabla varchar(1) = '~';

	SET NOCOUNT ON;
	
	BEGIN TRY

	DECLARE @veIdPersona INT;
	DECLARE @vcUsuario	VARCHAR(50);
	DECLARE @vcDatos	VARCHAR(MAX);
	
	DECLARE @vcId		VARCHAR(20);
	DECLARE @vcMessage		VARCHAR(MAX) = '';

	DECLARE @vcDni		VARCHAR(8);
	
	--> Variables Tabla
	DECLARE @vtabResponse TABLE(Reponse NVARCHAR(MAX));
	DECLARE @vtabParameters TABLE(Nro INT, Parameter NVARCHAR(MAX));
	INSERT INTO @vtabParameters (Nro, Parameter) SELECT * FROM dbo.fnSplitStringTable(@pvcData,@vcSepTabla);
	

		SELECT	@vcUsuario = Parameter FROM @vtabParameters WHERE Nro = 0;
		SELECT	@vcDatos = Parameter FROM @vtabParameters WHERE Nro = 1;

	SET @veIdPersona = ISNULL((SELECT LTRIM(RTRIM(Campo1)) FROM dbo.fnSplitStringRows(@vcDatos,@vcSepRegistro,@vcSepCampo)),'');
	SET @vcDni = ISNULL((SELECT LTRIM(RTRIM(Campo3)) FROM dbo.fnSplitStringRows(@vcDatos,@vcSepRegistro,@vcSepCampo)),'');

	
	IF @veIdPersona = ''
		BEGIN
			IF EXISTS (SELECT eIdPersona FROM General_Persona WHERE LTRIM(RTRIM(vDni)) = LTRIM(RTRIM(@vcDni)) AND bActivo = '1')
				BEGIN
					SET @vcMessage = 'Duplicado'
					SELECT @vcMessage
					RETURN;
				END
			INSERT INTO General_Persona 
			(eIdCatalogo, vDni, vNombre, vApellidoPaterno, vApellidoMaterno, vIdCataSexo, vTelefono, vCorreo, 
			vDireccion, vArchivoFoto, dFechaRegistro, vUsuarioRegistro, vIdPcRegistro, dFechaActualiza, vUsuarioActualiza,vIdPcActualiza,bActivo)
			SELECT LTRIM(RTRIM(Campo2)), LTRIM(RTRIM(Campo3)), LTRIM(RTRIM(Campo4)), LTRIM(RTRIM(Campo5)), 
			LTRIM(RTRIM(Campo6)), LTRIM(RTRIM(Campo7)), LTRIM(RTRIM(Campo8)), LTRIM(RTRIM(Campo9)), 
			LTRIM(RTRIM(Campo10)), '', GETDATE(), @vcUsuario,'',GETDATE(), @vcUsuario,'','1'
			FROM dbo.fnSplitStringRows(@vcDatos,@vcSepRegistro,@vcSepCampo);

			SET @vcId = CONVERT(VARCHAR,@@IDENTITY);
			SET @vcMessage = 'OK|Registro guardado';
		END
	ELSE
		BEGIN
		IF EXISTS (SELECT eIdPersona FROM General_Persona WHERE eIdPersona = @veIdPersona AND LTRIM(RTRIM(vDni)) = LTRIM(RTRIM(@vcDni)) AND bActivo = '1')
				BEGIN
					UPDATE General_Persona
					SET eIdCatalogo			= LTRIM(RTRIM(Campo2)),
						vNombre				= LTRIM(RTRIM(Campo4)),
						vApellidoPaterno	= LTRIM(RTRIM(Campo5)),
						vApellidoMaterno	= LTRIM(RTRIM(Campo6)),
						vIdCataSexo			= LTRIM(RTRIM(Campo7)),
						vTelefono			= LTRIM(RTRIM(Campo8)),
						vCorreo				= LTRIM(RTRIM(Campo9)),
						vDireccion			= LTRIM(RTRIM(Campo10)),
						dFechaActualiza		= GETDATE(),
						vUsuarioActualiza	= @vcUsuario
					FROM General_Persona as P
					INNER JOIN dbo.fnSplitStringRows(@vcDatos,@vcSepRegistro,@vcSepCampo) as C ON
					p.eIdPersona = @veIdPersona

					SET @vcId = @veIdPersona;
					SET @vcMessage = 'OK|Registro actualizado';

				END			
		ELSE
			IF EXISTS (SELECT 1 FROM General_Persona WHERE LTRIM(RTRIM(vDni)) = LTRIM(RTRIM(@vcDni)) AND bActivo = '1')
				BEGIN
					SET @vcMessage = 'Duplicado'
					SELECT @vcMessage
					RETURN;
				END
			ELSE
				BEGIN
					UPDATE P
					SET eIdCatalogo			= LTRIM(RTRIM(Campo2)),
						vDni				= LTRIM(RTRIM(Campo3)),
						vNombre				= LTRIM(RTRIM(Campo4)),
						vApellidoPaterno	= LTRIM(RTRIM(Campo5)),
						vApellidoMaterno	= LTRIM(RTRIM(Campo6)),
						vIdCataSexo			= LTRIM(RTRIM(Campo7)),
						vTelefono			= LTRIM(RTRIM(Campo8)),
						vCorreo				= LTRIM(RTRIM(Campo9)),
						vDireccion			= LTRIM(RTRIM(Campo10)),
						dFechaActualiza		= GETDATE(),
						vUsuarioActualiza	= @vcUsuario
					FROM General_Persona as P
					INNER JOIN dbo.fnSplitStringRows(@vcDatos,@vcSepRegistro,@vcSepCampo) as C ON
					p.eIdPersona = @veIdPersona

					SET @vcId = @veIdPersona;
					SET @vcMessage = 'OK|Registro actualizado';

				END
		END

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
	SELECT 'KO|' + CONVERT(VARCHAR,ERROR_NUMBER()) + ' - ' + ERROR_MESSAGE() + @vcSepTabla + @vcId;
 END CATCH

END
GO