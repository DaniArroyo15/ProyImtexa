-- =============================================
-- Author:		Daniel Arroyo Alvarado
-- Proyect:		Imtexa
-- Description:	Graba Categorias
-- =============================================
--select * from Tienda_Categoria

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'paCategoria_Grabar')
BEGIN
	DROP PROCEDURE paCategoria_Grabar
	PRINT 'DELETE: paCategoria_Grabar'
END
GO

CREATE PROCEDURE paCategoria_Grabar
(
@pData VARCHAR(MAX)
)
AS
BEGIN
	Declare @vcSepRegistro varchar(1) = '¬';
	Declare @vcSepCampo varchar(1) = '|';
	Declare @vcSepTabla varchar(1) = '~';

	SET NOCOUNT ON;
	
	Declare @ePost1 INT
	Declare @ePost2 INT
	Declare @ePost3 INT
	Declare @ePost4 INT

	Declare @eIdCategoria		varchar(10)
	Declare @vNombre			varchar(100)
	Declare @vDescripcion		varchar(100)
	Declare @vUsuario			varchar(100)

	Declare @vMensaje			varchar(100)

	SET @pData = LTRIM(RTRIM(@pData))
	SET @ePost1 = CHARINDEX('|',@pData,0)
	SET @eIdCategoria = SUBSTRING(@pData,1,@ePost1-1)
	SET @ePost2 = CHARINDEX('|',@pData,@ePost1+1)
	SET @vNombre = SUBSTRING(@pData,@ePost1+1,@ePost2-@ePost1-1)
	SET @ePost3 = CHARINDEX('|', @pData, @ePost2+1)
	SET @vDescripcion = SUBSTRING(@pData,@ePost2+1, @ePost3-@ePost2-1)
	SET @ePost4 = LEN(@pData)
	SET @vUsuario = SUBSTRING(@pData,@ePost3+1,@ePost4-@ePost3)


	IF @eIdCategoria = ''
		BEGIN
			IF EXISTS (SELECT eIdCategoria FROM Tienda_Categoria WHERE LTRIM(RTRIM(vNombre)) = LTRIM(RTRIM(@vNombre)))
				BEGIN
					SET @vMensaje = 'Duplicado'
					SELECT @vMensaje
					RETURN;
				END
			INSERT INTO Tienda_Categoria (vNombre, vDescripcion, dFechaRegistro, vUsuarioRegistro, vIdPcRegistro, dFechaActualiza, vUsuarioActualiza,vIdPcActualiza,bActivo)
			VALUES(@vNombre, @vDescripcion, GETDATE(), @vUsuario,'',GETDATE(), @vUsuario,'','1')
		END
	ELSE
		BEGIN
		IF EXISTS (SELECT eIdCategoria FROM Tienda_Categoria WHERE eIdCategoria = @eIdCategoria AND LTRIM(RTRIM(vNombre)) = LTRIM(RTRIM(@vNombre)))
				BEGIN
					UPDATE Tienda_Categoria
					SET vDescripcion = @vDescripcion,
					dFechaActualiza = GETDATE(),
					vUsuarioActualiza = @vUsuario
					WHERE eIdCategoria = @eIdCategoria
				END
		ELSE
			IF EXISTS (SELECT 1 FROM Tienda_Categoria WHERE LTRIM(RTRIM(vNombre)) = LTRIM(RTRIM(@vNombre)))
				BEGIN
					SET @vMensaje = 'Duplicado'
					SELECT @vMensaje
					RETURN;
				END
			ELSE
				BEGIN
					UPDATE Tienda_Categoria
					SET vNombre = @vNombre,
					vDescripcion = @vDescripcion,
					dFechaActualiza = GETDATE(),
					vUsuarioActualiza = @vUsuario
					WHERE eIdCategoria = @eIdCategoria
				END
		END
END
GO