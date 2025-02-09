USE BD_SISMA
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==========================================================================================================================
-- Proyecto			:	RR.HH Web
-- Fecha Creación	:	01/03/2024
-- Descripcion		:	Listar Menu de Accrso Por Usuario
-- Orden Servicio	:	--
-- Responsable		:	M. Guillermo Zambrano
-- ==========================================================================================================================

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'paGenSegMOpcion_ListarPorUsuario')
BEGIN
	DROP PROCEDURE paGenSegMOpcion_ListarPorUsuario
	PRINT 'SP Delete : paGenSegMOpcion_ListarPorUsuario';
END;
GO
CREATE Procedure paGenSegMOpcion_ListarPorUsuario
(
	@pvcData VARCHAR(20) 
)
AS
BEGIN
	SET NOCOUNT ON;
	SET DATEFORMAT DMY;
	SET ANSI_NULLS OFF;
	------------------//    
	SELECT 
	ISNULL((SELECT STUFF((
							SELECT		'¬' + convert(varchar(20),MEN.PK_eOpcion) 
										+ '|' + MEN.cNombre
										+ '|' + MEN.cUrl
										+ '|' + (CASE MEN.eIdPadre WHEN NULL THEN '0' ELSE convert(varchar(20), MEN.eIdPadre) END)
										+ '|' + ISNULL(MEN.cIcono,'')
							FROM		(
											 SELECT *
											 FROM	dbo.GenSegMOpcion (NOLOCK)  
											 WHERE	bMenu = 1
											 AND	cEstado <> 'DEL'	
										 ) AS MEN
							INNER JOIN	 dbo.GenSegDOpcionUsuario (NOLOCK) AS DMEN
									ON	 MEN.PK_eOpcion = DMEN.eOpcion
									AND	 DMEN.cEstado <> 'DEL'
							WHERE		 DMEN.ePersona = @pvcData
							ORDER BY	 MEN.eIdPadre
										,MEN.eIdOrden ASC
	FOR XML PATH(''), TYPE).value('(./text())[1]', 'nvarchar(max)'),1,1, '')),'') AS rpta
	---------------//
	SET NOCOUNT OFF;
END;
GO
IF EXISTS (SELECT * FROM sys.objects WHERE TYPE = 'P' AND NAME = 'paGenSegMOpcion_ListarPorUsuario')
	PRINT 'SP Create : paGenSegMOpcion_ListarPorUsuario';
	GRANT EXECUTE ON dbo.paGenSegMOpcion_ListarPorUsuario TO u_sisma;
GO