--USE PROVIASNAC
GO
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
	SELECT * FROM PerPapMTipoPapeleta
	EXEC paCategoria_ListarPorId '1~1'
*/
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'paCategoria_ListarPorId')
BEGIN
	DROP PROCEDURE dbo.paCategoria_ListarPorId
	PRINT '***'
	PRINT 'SP Delete : paCategoria_ListarPorId';
END;
GO
CREATE Procedure dbo.paCategoria_ListarPorId
(
	 @pvcData VARCHAR(MAX)
)
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
	--
	DECLARE @veId VARCHAR(20);
	---
	SELECT @veId = CONVERT(INT,@pvcData);
	---
	SELECT	  CONVERT(VARCHAR(20),@veId)
			+ @vcSepCampo + ISNULL(vNombre ,'')
			+ @vcSepCampo + ISNULL(vDescripcion,'')
			+ @vcSepCampo + IIF(LTRIM(RTRIM(bActivo))=1,'1','0')
	FROM	  dbo.Almacen_Categoria (NOLOCK)
	WHERE	  PK_eCategoria = @veId;
END;
GO
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'paCategoria_ListarPorId')
BEGIN
	--GRANT EXECUTE ON dbo.paCategoria_ListarPorId TO dbUser;
	PRINT 'SP Create : paCategoria_ListarPorId';
	PRINT '***'
END
GO