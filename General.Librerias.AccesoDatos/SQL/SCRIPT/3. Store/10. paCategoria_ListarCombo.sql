-- =============================================
-- Author:		Daniel Arroyo Alvarado
-- Proyect:		Imtexa
-- Description:	Listar Categoria
-- =============================================

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'paCategoria_ListarCombo')
BEGIN
	DROP PROCEDURE dbo.paCategoria_ListarCombo
	PRINT '***'
	PRINT 'SP Delete : paCategoria_ListarCombo';
END;
GO
CREATE PROCEDURE dbo.paCategoria_ListarCombo
AS
BEGIN

		---| Variables de Corte
	DECLARE @vcSepRegistro	VARCHAR(1) = '¬';
	DECLARE @vcSepCampo		VARCHAR(1) = '|';

		(Select STUFF((Select @vcSepRegistro + CONVERT(VARCHAR(10),eIdCategoria)
						+ @vcSepCampo + vNombre
		FROM Tienda_Categoria
		FOR XML PATH('')), 1, 1, ''))
END