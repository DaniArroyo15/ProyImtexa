--USE PROVIASNAC
GO
-- ==========================================================================================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==========================================================================================================================
-- Proyecto			:	RR.HH Web
-- Fecha Creación	:	
-- Descripcion		:	
-- Orden Servicio	:	--
-- Responsable		:	Guillermo Zambrano
-- ==========================================================================================================================
/*
	SELECT * FROM dbo.Ventas_Cliente;
	--
	EXEC dbo.paCliente_Listar
*/
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'paCliente_Listar')
BEGIN
	DROP PROCEDURE paCliente_Listar
	PRINT '***'
	PRINT 'SP Delete : paCliente_Listar';
END;
GO
CREATE Procedure dbo.paCliente_Listar
As
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
	--|
	DECLARE @vcRetorno		VARCHAR(MAX);
	DECLARE @vcCabecera		VARCHAR(MAX);
	DECLARE @vcRegistros	VARCHAR(MAX);
	--|
	SET @vcCabecera =  'Id|Codigo|Documento|Razon Social|Telefono|Direccion|Fec. Registro|Estado'
	+ @vcSepRegistro + '50|100|100|300|100|200|100|100' 
	+ @vcSepRegistro + 'String|String|String|String|String|String|String|String';
	--|
	SET @vcRegistros =  ISNULL((SELECT STUFF ((
												SELECT		@vcSepRegistro + convert(varchar(10), PK_eCliente)
															+ @vcSepCampo + vCodigo
															+ @vcSepCampo + vDocumento
															+ @vcSepCampo + vRazonSocial
															+ @vcSepCampo + vNroTelefono
															+ @vcSepCampo + vDireccion
															+ @vcSepCampo + FORMAT(dFecRegistro, 'dd/MM/yyyy')
															+ @vcSepCampo + CASE WHEN bActivo = 1 THEN 'Activo' ELSE 'Inactivo' END
												FROM		dbo.Ventas_Cliente (NOLOCK)
												ORDER BY	PK_eCliente DESC
								FOR XML PATH('')),1,1,'')),'')
	--|
	SET @vcRetorno =	CASE 
					WHEN @vcRegistros = '' 
					THEN @vcCabecera 
					ELSE @vcCabecera + @vcSepRegistro + @vcRegistros 
					END
	--|
	SELECT @vcRetorno;
END;
GO
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'paCliente_Listar')
BEGIN
	--GRANT EXECUTE ON dbo.paCliente_Listar TO dbUser;
	PRINT 'SP Create : paCliente_Listar';
	PRINT '***'
END
GO