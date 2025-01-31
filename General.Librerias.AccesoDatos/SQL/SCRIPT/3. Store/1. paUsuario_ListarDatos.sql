/*
paUsuario_ListarDatos 'DARROYO|ADMIN'

*/

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'paUsuario_ListarDatos')
BEGIN
	DROP PROCEDURE paUsuario_ListarDatos
	PRINT 'SP Delete : paUsuario_ListarDatos';
END;
GO
CREATE Procedure paUsuario_ListarDatos
(
	@pvcData VARCHAR(MAX) 
)
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @vcSepRegistro VARCHAR(1) = '¬';
	DECLARE @vcSepCampo VARCHAR(1) = '|';
	DECLARE @vcSepTabla VARCHAR(1) = '~';
	
	DECLARE @vePos1 INT
	DECLARE @vePos2 INT

	DECLARE @vcUsuario	VARCHAR(100)
	DECLARE @vcPassword VARCHAR(100)

	SET @pvcData = LTRIM(RTrim(@pvcData))
	SET @vePos1 = CharIndex('|',@pvcData,0)
	SET @vcUsuario = SUBSTRING(@pvcData,1,@vePos1-1)
	SET @vePos2 = Len(@pvcData)
	SET @vcPassword = SUBSTRING(@pvcData,@vePos1+1,@vePos2-@vePos1)

---- 

	SELECT
	ISNULL((SELECT STUFF ((SELECT TOP 2 @vcSepRegistro + CONVERT(varchar(20),a.eIdUsuario)
							+ @vcSepCampo + a.vUsuario
							+ @vcSepCampo + b.vDni
							+ @vcSepCampo + b.vNombre + ' ' + b.vApellidoPaterno + ' ' + b.vApellidoMaterno
			FROM Seguridad_Usuario (nolock) a
			LEFT JOIN General_Persona (nolock) b ON
			a.eIdPersona = b.eIdPersona
			WHERE a.vUsuario = @vcUsuario AND a.vClave = @vcPassword AND a.bActivo = '1'
			FOR XML PATH('')),1,1,'')),'')	

END
GO

/*
GRANT EXECUTE ON paUsuario_ListarDatos TO DBUSER
GO
*/

