
-- =============================================
-- Author:		Daniel Arroyo Alvarado
-- Proyect:		Imtexa
-- Description:	Importa Producto
/*
select * from Tienda_Producto
delete from Tienda_Producto
*/
-- =============================================

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'paProducto_Importar')
BEGIN
	DROP PROCEDURE dbo.paProducto_Importar
	PRINT '***'
	PRINT 'SP Delete : paProducto_Importar';
END
GO
CREATE PROCEDURE dbo.paProducto_Importar
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
	DECLARE @vcMessage	 VARCHAR(MAX) = '';
	---|
	---| Variables de Corte
	DECLARE @vcSepRegistro	VARCHAR(1) = '¬';
	DECLARE @vcSepCampo		VARCHAR(1) = '|';
	DECLARE @vcSepTabla		VARCHAR(1) = '~';
	DECLARE @vcSepOpcional	VARCHAR(1) = '^';
	DECLARE @vcSepValor		VARCHAR(1) = ',';
	---|
	---| Variables de Entrada
	DECLARE @vcUsuario		VARCHAR(MAX);
	DECLARE @vcCabecera		VARCHAR(MAX);
	DECLARE @vcDatos		VARCHAR(MAX);

	DECLARE @vCategoria		VARCHAR(2);
	DECLARE @vFechaRegistro	DATE = GETDATE();
	DECLARE @vCodigo		VARCHAR(MAX);
	---|
	DECLARE @vcId			VARCHAR(MAX);
	DECLARE @veIdUsuario	INT;
	---|
	BEGIN TRY
		---|
		--> Variables Tabla
		DECLARE @vtabResponse TABLE(Reponse NVARCHAR(MAX));
		DECLARE @vtabParameters TABLE(Nro INT, Parameter NVARCHAR(MAX));
		INSERT INTO @vtabParameters (Nro, Parameter) SELECT * FROM dbo.fnSplitStringTable(@pvcData,@vcSepTabla);
		--
		SELECT	@vcUsuario = CONVERT(INT,Parameter) FROM @vtabParameters WHERE Nro = 0;
		SELECT	@vcCabecera = Parameter FROM @vtabParameters WHERE Nro = 1;
		SELECT	@vcDatos = Parameter FROM @vtabParameters WHERE Nro = 2;
		--
		--| *********************************************************************************
		--
		--
		INSERT INTO	dbo.Tienda_Producto
					(eIdCategoria, vCodigo, vDescripcion,dNeto, dBruto,dTara, vProveedor, vEstado,dFechaRegistro, vUsuarioRegistro,
					vIdPcRegistro, dFechaActualiza, vUsuarioActualiza, vIdPcActualiza)
		SELECT		 IIF(LTRIM(RTRIM(Campo1))='Hilos',1,2),FORMAT(@vFechaRegistro, 'yyyyMMdd') + '-' + LTRIM(RTRIM(Campo5)),
		            '',LTRIM(RTRIM(Campo2)), LTRIM(RTRIM(Campo3)), CONVERT(DECIMAL(20,2),LTRIM(RTRIM(Campo2))) - CONVERT(DECIMAL(20,2),LTRIM(RTRIM(Campo3))),  
					'CHINA',IIF(LTRIM(RTRIM(Campo4))='Disponible',1,0),@vFechaRegistro,@vcUsuario,'',@vFechaRegistro,@vcUsuario,''
		FROM		 dbo.fnSplitStringRows(@vcDatos,@vcSepRegistro,@vcSepCampo)
		WHERE		RTRIM(LTRIM(Campo1)) <> '';
		---------------------------------------
		SET @vcId = CONVERT(VARCHAR(20),@@IDENTITY);
		SET @vcMessage = 'OK|Importación satisfactoria';
		
		SET @vCategoria = (SELECT eIdCategoria FROM Tienda_Producto WHERE eIdProducto = @vcId)
		---
		INSERT 
		INTO	@vtabResponse
		EXEC	dbo.paProducto_ListaPorCategoria @vCategoria;
		---
		goFINAL:
		SELECT	  @vcMessage						--| 0. Mensaje
				+ @vcSepTabla + @vcId				--| 1. Datos del registro
				+ @vcSepTabla + Reponse				--| 2. Listado de Retorno
		FROM	  @vtabResponse;
		---
	END TRY
	BEGIN CATCH
		SELECT 'KO|' + CONVERT(VARCHAR,ERROR_NUMBER()) + '-' + ERROR_MESSAGE() + @vcSepTabla + @vcId;
	END CATCH
	------------------//
	SET NOCOUNT OFF;
END;
GO
