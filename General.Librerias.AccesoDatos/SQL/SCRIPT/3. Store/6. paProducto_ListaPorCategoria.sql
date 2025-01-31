/*
-- =============================================
 Author:		Daniel Arroyo Alvarado
 Proyect:		Imtexa
 Description:	Lista Productos por Categoria
-- =============================================
select * from Tienda_Producto

paProducto_ListaPorCategoria 2
*/


IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'paProducto_ListaPorCategoria')
BEGIN
	DROP PROCEDURE paProducto_ListaPorCategoria
	PRINT 'DELETE: paProducto_ListaPorCategoria'
END
GO

CREATE PROCEDURE paProducto_ListaPorCategoria 
(
@peIdCategoria	INT
)
AS
BEGIN
	Declare @vcSepRegistro varchar(1) = '¬';
	Declare @vcSepCampo varchar(1) = '|';
	Declare @vcSepTabla varchar(1) = '~';

SELECT 
		 'eIdProducto|Categoria|Código|Descripcion|Neto|Bruto|Tara|Proveedor|Estado|Fe registro' + @vcSepRegistro
	+ '30|50|50|200|40|40|40|100|100|100' + @vcSepRegistro
	+ 'String|String|String|String|String|String|String|String|String|String' + @vcSepRegistro +
	ISNULL((SELECT STUFF ((SELECT @vcSepRegistro + CONVERT(VARCHAR(10), eIdProducto)
							+ @vcSepCampo + IIF(CONVERT(VARCHAR(10),eIdCategoria) = '1','HILOS','MAQUINA')
							+ @vcSepCampo + vCodigo
							+ @vcSepCampo + vDescripcion
							+ @vcSepCampo + CONVERT(VARCHAR(20),dNeto)
							+ @vcSepCampo + CONVERT(VARCHAR(20),dBruto)
							+ @vcSepCampo + CONVERT(VARCHAR(20),dTara)
							+ @vcSepCampo + vProveedor
							+ @vcSepCampo + IIF(vEstado='1','VENDIDO','DISPONIBLE')
							+ @vcSepCampo + CONVERT(varchar(20), dFechaRegistro,120)
			FROM Tienda_Producto (nolock)
			WHERE eIdCategoria = @peIdCategoria AND bActivo = '1'
			FOR XML PATH('')),1,1,'')),'')
END
GO
