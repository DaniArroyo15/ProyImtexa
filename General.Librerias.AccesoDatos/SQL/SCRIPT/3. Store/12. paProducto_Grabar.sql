-- =============================================
-- Author:		Daniel Arroyo Alvarado
-- Proyect:		Imtexa
-- Description:	Graba Producto
-- =============================================
/*
select * from Tienda_Producto
paProducto_Grabar 'DARROYO~3|1|lololol|r54|chino|12|0.5|0'
*/
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'paProducto_Grabar')
BEGIN
	DROP PROCEDURE paProducto_Grabar
	PRINT 'DELETE: paProducto_Grabar'
END
GO

CREATE PROCEDURE paProducto_Grabar
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

		IF(@veIdProducto = '')
			BEGIN
				INSERT INTO Tienda_Producto
				(eIdCategoria, vCodigo, vDescripcion,dNeto, dBruto,dTara, vProveedor, vEstado,dFechaRegistro, vUsuarioRegistro,
				vIdPcRegistro, dFechaActualiza, vUsuarioActualiza, vIdPcActualiza, bActivo)
				SELECT IIF(LTRIM(RTRIM(Campo2))='1',1,2),
				FORMAT(@vFechaRegistro, 'yyyyMMdd') + '-' + LTRIM(RTRIM(Campo4)),
		       LTRIM(RTRIM(Campo3)),CONVERT(DECIMAL(20,2),LTRIM(RTRIM(Campo6))), CONVERT(DECIMAL(20,2),LTRIM(RTRIM(Campo7))), 
			   CONVERT(DECIMAL(20,2),LTRIM(RTRIM(Campo6))) - CONVERT(DECIMAL(20,2),LTRIM(RTRIM(Campo7))),  
				LTRIM(RTRIM(Campo5)),IIF(LTRIM(RTRIM(Campo8))='1',1,0),@vFechaRegistro,@vcUsuario,'',@vFechaRegistro,@vcUsuario,'','1'
				FROM dbo.fnSplitStringRows(@vcDatos,@vcSepRegistro,@vcSepCampo)		

				SET @vcId = CONVERT(VARCHAR(MAX),@@IDENTITY)
				SET @veIdCategoria = (SELECT eIdCategoria FROM Tienda_Producto WHERE eIdProducto = @vcId)

				SET @vcMessage = 'OK|Registro satisfactorio';
			END

		ELSE
			BEGIN
				UPDATE P
				SET eIdCategoria = CONVERT(INT,LTRIM(RTRIM(Campo2))),
					vDescripcion = LTRIM(RTRIM(Campo3)),
					dNeto		 = CONVERT(DECIMAL(20,2),LTRIM(RTRIM(Campo6))),
					dBruto		 = CONVERT(DECIMAL(20,2),LTRIM(RTRIM(Campo7))),
					dTara		 = CONVERT(DECIMAL(20,2),LTRIM(RTRIM(Campo6))) - CONVERT(DECIMAL(20,2),LTRIM(RTRIM(Campo7))),
					vProveedor	 = LTRIM(RTRIM(Campo5)),
					vEstado		 = LTRIM(RTRIM(Campo8)),
					vUsuarioActualiza	= @vcUsuario,
					dFechaActualiza		= @vFechaRegistro
				FROM Tienda_Producto as P
				INNER JOIN dbo.fnSplitStringRows(@vcDatos,@vcSepRegistro,@vcSepCampo) as T ON
				P.eIdProducto = @veIdProducto
			
				SET @veIdCategoria = (SELECT eIdCategoria FROM Tienda_Producto WHERE eIdProducto = @veIdProducto);
				SET @vcId = @veIdProducto;
				SET @vcMessage = 'OK|Actualización satisfactoria';			
			END

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