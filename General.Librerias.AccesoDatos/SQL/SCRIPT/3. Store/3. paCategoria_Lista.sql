-- =============================================
-- Author:		Daniel Arroyo Alvarado
-- Proyect:		Imtexa
-- Description:	Lista Categorias
-- =============================================
--select * from Tienda_Categoria

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'paCategoria_Lista')
BEGIN
	DROP PROCEDURE paCategoria_Lista
	PRINT 'SP DELETE: paCategoria_Lista'
END
GO

CREATE PROCEDURE paCategoria_Lista 
AS
BEGIN
	Declare @vcSepRegistro varchar(1) = '¬';
	Declare @vcSepCampo varchar(1) = '|';
	Declare @vcSepTabla varchar(1) = '~';

SELECT 
		 'eIdCategoria|Nombre|Descripcion|Fecha registro|Activo	' + @vcSepRegistro
	+ '50|100|200|100|100' + @vcSepRegistro
	+ 'String|String|String|String|String' + @vcSepRegistro +
	ISNULL((SELECT STUFF ((SELECT @vcSepRegistro + convert(varchar(10), eIdCategoria)
							+ @vcSepCampo + vNombre
							+ @vcSepCampo + vDescripcion
							+ @vcSepCampo + CONVERT(varchar(20), dFechaRegistro,120)
							+ @vcSepCampo + CASE WHEN bActivo = '1' THEN 'Activo' ELSE 'Inactivo' END
			FROM Tienda_Categoria (nolock)
			FOR XML PATH('')),1,1,'')),'')
END
GO
