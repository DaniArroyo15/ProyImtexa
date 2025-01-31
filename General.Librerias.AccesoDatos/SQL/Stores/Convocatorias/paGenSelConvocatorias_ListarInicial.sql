USE BD_SISMA
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
-- Responsable		:	
-- ==========================================================================================================================
/*
	EXEC paGenSelConvocatorias_ListarInicial
*/
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'paGenSelConvocatorias_ListarInicial')
BEGIN
	DROP PROCEDURE paGenSelConvocatorias_ListarInicial
	PRINT 'SP Delete : paGenSelConvocatorias_ListarInicial';
END;
GO
CREATE Procedure [dbo].[paGenSelConvocatorias_ListarInicial]
As
BEGIN
	DECLARE @sepRegistro VARCHAR(1) = '¬';
	DECLARE @sepCampo	 VARCHAR(1) = '|';
	DECLARE @sepTabla	 VARCHAR(1) = '~';
	--|
	SELECT
	--|
	--| 0. Periodo
	--|-----------------------------|
	ISNULL((SELECT STUFF ((
							SELECT		@sepRegistro + CONVERT(VARCHAR(20),PK_eAnio)
							FROM		dbo.GenPerHAnual (NOLOCK) 
							WHERE		FK_cProceso = 'PRO'
							AND			lUsoSistema = 0
							GROUP BY	FK_cProceso,PK_eAnio
							ORDER BY	PK_eAnio DESC
					FOR XML PATH('')),1,1,'')),'')
	--|
	--| 1. Tipo
	--|-----------------------------|
	+ @sepTabla +
	ISNULL((SELECT STUFF((
							SELECT	@sepRegistro + CONVERT(VARCHAR(150),PK_eTProceso)
									+ @sepCampo + cTProceso
							FROM	 dbo.PerSelTProceso (NOLOCK)
							WHERE	lDesactivado = 0
							AND		lUsoSistema = 0
			FOR XML PATH('')), 1, 1, '')),'')
	--|
	--| 2. Estados
	--|-----------------------------|
	+ @sepTabla +
	ISNULL((SELECT STUFF((
							SELECT	 @sepRegistro + CONVERT(VARCHAR(150),PK_eTProcEstado)
									+ @sepCampo + cTProcEstado
							FROM	 dbo.PerSelTProcesoEst (NOLOCK)
							WHERE	 lUsoSistema = 0
							ORDER BY eOrden
			FOR XML PATH('')), 1, 1, '')),'')

			SELECT * FROM PerSelTProcesoEst

END;
GO
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'paGenSelConvocatorias_ListarInicial')
	PRINT 'SP Create : paGenSelConvocatorias_ListarInicial';
	GRANT EXECUTE ON dbo.paGenSelConvocatorias_ListarInicial TO u_sisma;
GO