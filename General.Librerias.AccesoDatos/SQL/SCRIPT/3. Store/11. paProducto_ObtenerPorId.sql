/*
-- =============================================
 Author:		Daniel Arroyo Alvarado
 Proyect:		Imtexa
 Description:	Lista Producto por ID
-- =============================================
	select * from Tienda_Producto
	paProducto_ObtenerPorId 16
*/

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'paProducto_ObtenerPorId')
BEGIN
	DROP PROCEDURE paProducto_ObtenerPorId
	PRINT 'DELETE: paProducto_ObtenerPorId'
END
GO

CREATE PROCEDURE paProducto_ObtenerPorId 
(
@peIdProducto	INT
)
AS
BEGIN

	Declare @vcSepCampo varchar(1) = '|';

SELECT ISNULL((SELECT convert(varchar(10), eIdProducto)
							+ @vcSepCampo + CONVERT(VARCHAR(20),eIdCategoria)
							+ @vcSepCampo + vDescripcion
							+ @vcSepCampo + vProveedor
							+ @vcSepCampo + CONVERT(VARCHAR(MAX),dNeto)
							+ @vcSepCampo + CONVERT(VARCHAR(MAX),dBruto)
							+ @vcSepCampo + vEstado
			FROM Tienda_Producto (nolock)
			WHERE eIdProducto = @peIdProducto AND bActivo = '1'),'')
END
GO