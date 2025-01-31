-- =============================================
-- Author:		Daniel Arroyo Alvarado
-- Description:	Listar personas 
-- =============================================

IF EXISTS (SELECT * FROM sys.objects WHERE type='P' AND name='paPersonal_Listar')
BEGIN
	DROP PROCEDURE paPersonal_Listar
	PRINT 'SP DELETE: paPersonal_Listar'
END
GO
CREATE PROCEDURE paPersonal_Listar 
AS
BEGIN

	Declare @vcSepRegistro varchar(1) = '¬';
	Declare @vcSepCampo varchar(1) = '|';
	Declare @vcSepTabla varchar(1) = '~';

SELECT 
			'eIdPersona|DNI|Nombre y apellido|Telefono|Correo	' + @vcSepRegistro
			+ '50|100|300|100|100' + @vcSepRegistro
			+ 'String|String|String|String|String' + @vcSepRegistro +
			ISNULL((SELECT STUFF ((SELECT @vcSepRegistro + convert(varchar(10), eIdPersona)
							+ @vcSepCampo + vDni
							+ @vcSepCampo + vNombre + ' ' + vApellidoPaterno + ' ' + vApellidoMaterno
							+ @vcSepCampo + vTelefono
							+ @vcSepCampo + vCorreo
			FROM General_Persona (nolock)
			WHERE bActivo = '1'
			FOR XML PATH('')),1,1,'')),'')

			+ @vcSepTabla + 

			(Select STUFF((Select @vcSepRegistro + CONVERT(VARCHAR(10),eIdCatalogo)
						+ @vcSepCampo + vDescripcion
		FROM Sistema_Catalogo
		WHERE eIdCatalogoPadre = '1'
		FOR XML PATH('')), 1, 1, ''))

		+ @vcSepTabla + 

			(Select STUFF((Select @vcSepRegistro + CONVERT(VARCHAR(10),eIdCatalogo)
						+ @vcSepCampo + vDescripcion
		FROM Sistema_Catalogo
		WHERE eIdCatalogoPadre = '4'
		FOR XML PATH('')), 1, 1, ''))
END
GO


