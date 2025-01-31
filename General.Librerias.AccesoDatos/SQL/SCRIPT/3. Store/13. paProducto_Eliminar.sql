-- =============================================
-- Author:		Daniel Arroyo Alvarado
-- Proyect:		Imtexa
-- Description:	Elimina Producto (Inactiva)
-- =============================================
/*
select * from Tienda_Producto
paProducto_Eliminar 'DARROYO~2'
*/
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'paProducto_Eliminar')
BEGIN
	DROP PROCEDURE paProducto_Eliminar
	PRINT 'DELETE: paProducto_Eliminar'
END
GO

CREATE PROCEDURE paProducto_Eliminar
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

	DECLARE @veIdProducto	INT;
	DECLARE @veIdCategoria	VARCHAR(9);
	DECLARE @vFechaRegistro	DATE = GETDATE();

	--> Variables Tabla
		DECLARE @vtabResponse TABLE(Reponse NVARCHAR(MAX));
		DECLARE @vtabParameters TABLE(Nro INT, Parameter NVARCHAR(MAX));
		INSERT INTO @vtabParameters (Nro, Parameter) SELECT * FROM dbo.fnSplitStringTable(@pvcData,@vcSepTabla);
		--
		SELECT	@vcUsuario = Parameter FROM @vtabParameters WHERE Nro = 0;
		SELECT	@vcDatos = Parameter FROM @vtabParameters WHERE Nro = 1;
		

		SET @vFechaRegistro = GETDATE();
		SET @veIdProducto = ISNULL((SELECT LTRIM(RTRIM(Campo1)) FROM dbo.fnSplitStringRows(@vcDatos,@vcSepRegistro,@vcSepCampo)),'')

				UPDATE P
				SET bActivo = '0',
					vUsuarioActualiza	= @vcUsuario,
					dFechaActualiza		= @vFechaRegistro
				FROM Tienda_Producto as P
				INNER JOIN dbo.fnSplitStringRows(@vcDatos,@vcSepRegistro,@vcSepCampo) as T ON
				P.eIdProducto = @veIdProducto

			SET @veIdCategoria = (SELECT eIdCategoria FROM Tienda_Producto WHERE eIdProducto = @veIdProducto);
			SET @vcId = @veIdProducto;
			SET @vcMessage = 'OK|Actualización satisfactoria';

		INSERT 
		INTO @vtabResponse
		EXEC dbo.paProducto_ListaPorCategoria @veIdCategoria;

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