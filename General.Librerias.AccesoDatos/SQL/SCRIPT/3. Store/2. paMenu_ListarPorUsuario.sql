-- ==========================================================================================================================
-- Proyecto			:	IMTEXA
-- Fecha Creación	:	01/10/2024
-- Descripcion		:	Listar menú por usuario
-- Responsable		:	Daniel Arroyo Alvarado
-- ==========================================================================================================================
-- paMenu_ListarOpcionPorUsuario '1'
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'paMenu_ListarOpcionPorUsuario')
BEGIN
	DROP PROCEDURE paMenu_ListarOpcionPorUsuario
	PRINT 'SP Delete : paMenu_ListarOpcionPorUsuario';
END;
GO
CREATE Procedure paMenu_ListarOpcionPorUsuario
(
	@peIdUsuario VARCHAR(20) 
)
AS
BEGIN
	SET NOCOUNT ON;
	SET ANSI_NULLS OFF;

	DECLARE @vSepRegistro	VARCHAR(1) = '¬'
	DECLARE @vSepCampo		VARCHAR(1) = '|'
	------------------//    
	SELECT 
	ISNULL((Select STUFF((
							SELECT		@vSepRegistro + convert(varchar(20),OP.eIdOpcion) 
										+ @vSepCampo + OP.vNombre 
										+ @vSepCampo + OP.vRuta 
										+ @vSepCampo + (CASE OP.eIdOpcionPadre WHEN 0 THEN '0' ELSE convert(varchar(20), OP.eIdOpcionPadre) END)
										+ @vSepCampo + ISNULL(OP.vIcon,'')
							FROM Sistema_Opcion OP 
							INNER JOIN	Seguridad_OpcionUsuario US ON
							OP.eIdOpcion = US.eIdOPcion
							WHERE		US.eIdUsuario = @peIdUsuario
							ORDER BY	OP.vNuOrden
	FOR XML PATH('')), 1, 1, '')),'') AS rpta
	---------------//
	SET NOCOUNT OFF;
END;
GO

--GRANT EXECUTE ON paMenu_ListarOpcionPorUsuario TO DBUSER
--GO