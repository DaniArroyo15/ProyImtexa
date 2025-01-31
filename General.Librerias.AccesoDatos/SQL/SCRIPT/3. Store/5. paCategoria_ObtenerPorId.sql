/*
-- =============================================
 Author:		Daniel Arroyo Alvarado
 Proyect:		Imtexa
 Description:	Lista Categoria por ID
-- =============================================
	select * from Tienda_Categoria
	paCategoria_ObtenerPorId 1
*/

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'paCategoria_ObtenerPorId')
BEGIN
	DROP PROCEDURE paCategoria_ObtenerPorId
	PRINT 'DELETE: paCategoria_ObtenerPorId'
END
GO

CREATE PROCEDURE paCategoria_ObtenerPorId 
(
@pData	INT
)
AS
BEGIN

	Declare @vcSepCampo varchar(1) = '|';

SELECT ISNULL((SELECT convert(varchar(10), eIdCategoria)
							+ @vcSepCampo + vNombre
							+ @vcSepCampo + convert(varchar(1), bActivo)
							+ @vcSepCampo + vDescripcion							
			FROM Tienda_Categoria (nolock)
			WHERE eIdCategoria = @pData),'')
END
GO
