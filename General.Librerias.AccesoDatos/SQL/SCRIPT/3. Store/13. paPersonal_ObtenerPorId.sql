/*
-- =============================================
 Author:		Daniel Arroyo Alvarado
 Proyect:		Imtexa
 Description:	Lista Persona por ID
-- =============================================
	select * from General_Persona
	paPersonal_ObtenerPorId 1
*/

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'paPersonal_ObtenerPorId')
BEGIN
	DROP PROCEDURE paPersonal_ObtenerPorId
	PRINT 'DELETE: paPersonal_ObtenerPorId'
END
GO

CREATE PROCEDURE paPersonal_ObtenerPorId 
(
@peIdPersona	INT
)
AS
BEGIN

	Declare @vcSepCampo varchar(1) = '|';

SELECT ISNULL((SELECT convert(varchar(10), eIdPersona)
							+ @vcSepCampo + CONVERT(VARCHAR(2),eIdCatalogo)
							+ @vcSepCampo + vDni
							+ @vcSepCampo + vNombre
							+ @vcSepCampo + vApellidoPaterno
							+ @vcSepCampo + vApellidoMaterno
							+ @vcSepCampo + vIdCataSexo
							+ @vcSepCampo + vTelefono
							+ @vcSepCampo + vCorreo
							+ @vcSepCampo + vDireccion							
			FROM General_Persona (nolock)
			WHERE eIdPersona = @peIdPersona),'')
END
GO
