--USE PROVIASNAC
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==========================================================================================================================|
-- Proyecto			: Demo
-- Fecha Creación	:	
-- Descripcion		:	
-- Orden Servicio	:	
-- Responsable		: Guillermo Zambrano
-- ==========================================================================================================================|
/*
	SELECT * FROM Ventas_Cliente
*/
-- ==========================================================================================================================|
/*
	EXEC dbo.paCliente_Importar '1~RAZON SOCIAL|DIRECCION|RUC|CELULAR~AARON|LA VICTORIA||922342144¬ABELARDO CUEVAS|SJL - 912990067 - 924277435||912990067¬ALBERTO APAZA|||¬ALEX PELUCA|LA VICTORIA||¬ALEX SOTO|SAN JUAN DE LURIGANCHO||929614580¬ALFREDO LUNA CHAVEZ|SAN JUAN DE LURIGANCHO|10450383487|923645275¬ANDRES|||¬ANTONY|||¬BRUNO|||¬CHRISTIAN |||¬COCA|AMERICA - LA VICTORIA||931936400¬CRISTOPHER|||¬DANIEL DIAZ|||¬DANILO|SJL||962860670¬DARIO YATACO|LA VICTORIA||¬DIEGO GAOSTEX|SJL||¬EDWIN CHARRY|SJL||990318213¬EFRAIN PINO HUAMAN|JR. PORVENIR 225 - JULIACA||969309131¬ELI CHACON|LA VICTORIA||953821503¬ELMER|LA VICTORIA||981422614¬FLORES|JR. GIRIBALDI 1286 - LA VICTORIA||968966689¬GIANELLA|JR. GIRIBALDI 450||956384910¬GIOVANNI|LA VICTORIA||998252286¬GREGORIO|JR. HUAMANGA 669 - LA VICTORIA||902707007¬GRUPO INDUSTRIAL SAN IGNACIO S.A.C.|AV. LOS PROCERES INT. 1A LT. 1-A2 MZ. N-1 URB. FUNDO DE CAMPOY - SAN JUAN DE LURIGANCHO|20601509513|947889185¬HECTOR CALIXTO ROSADO CUSME| AGUAS VERDES||¬INVERSIONES AWAY S.A.C.|LR. ACORA LT. 10 MZ. F URB. MANGOMARCA - SAN JUAN DE LURIGANCHO - LIMA|20513353767|981298564¬JAIME MILLA|SAN LUIS||916597402¬JARAMILLO MAELLA|JR. AMERICA NRO. 3345 INT. 1 - LA VICTORIA|10469694661|989164897¬JAVIER VASQUEZ|||¬JHONNY KAKI|LA VICTORIA||959793070¬JOSÉ MÉNDEZ|||¬JUAN JOPE|||947977829¬JUSTO TORRES|LA VICTORIA||994223639¬KEVIN|LA VICTORIA||¬LIDER SOTO|||947383149¬LUCHO MORENO|LA VICTORIA||947261597¬MARCO VALVERDE|AMERICA - LA VICTORIA||988986233¬MEDINA|||927966371¬MELQUIADEZ|||995880331¬MELLAN SARMIENTO|||¬MIJAEL|LA VICTORIA||¬MUESTRAS|||¬NOE SOTO|||¬POCHO RAMOS|LA VICTORIA||980428017¬REYNALDO (THOMAS)|||985142504¬RICHARD|SURCO||996822979¬RIVERA|AMERICA - LA VICTORIA||948622529¬RONALDO (KLEVER)|||925050693¬SILVERIO|||¬SILVIA KEYNES|SAN JUAN DE LURIGANCHO||960492919¬SR. RICHARD AMERICA|AMERICA - LA VICTORIA||942036258¬SUSANA|SJL||997049571¬VICTOR GARCIA|||¬VILLALVA|LA VICTORIA||¬WILDER|LA VICTORIA||981527684¬YOSSFEE|LA VICTORIA||¬'
*/
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'paCliente_Importar')
BEGIN
	DROP PROCEDURE dbo.paCliente_Importar
	PRINT '***'
	PRINT 'SP Delete : paCliente_Importar';
END
GO
CREATE PROCEDURE dbo.paCliente_Importar
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
	DECLARE @veIdPersona	INT;
	DECLARE @vcCabecera		VARCHAR(MAX);
	DECLARE @vcDatos		VARCHAR(MAX);
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
		SELECT	@veIdPersona = CONVERT(INT,Parameter) FROM @vtabParameters WHERE Nro = 0;
		SELECT	@vcCabecera = Parameter FROM @vtabParameters WHERE Nro = 1;
		SELECT	@vcDatos = Parameter FROM @vtabParameters WHERE Nro = 2;
		--
		--| *********************************************************************************
		--
		SELECT	@veIdUsuario = eIdUsuario FROM dbo.Seguridad_Usuario (NOLOCK) WHERE eIdPersona = @veIdPersona;
		--
		INSERT INTO	dbo.Ventas_Cliente
					(	
					 vRazonSocial
					,vDireccion
					,vDocumento
					,vNroTelefono
					,eUsuario
					)
		SELECT		 LTRIM(RTRIM(Campo1))
					,LTRIM(RTRIM(Campo2))
					,LTRIM(RTRIM(Campo3))
					,LTRIM(RTRIM(Campo4))
					,@veIdUsuario
		FROM		 dbo.fnSplitStringRows(@vcDatos,@vcSepRegistro,@vcSepCampo)
		--
		---------------------------------------
		SET @vcId = CONVERT(VARCHAR(20),@@IDENTITY);
		SET @vcMessage = 'OK|Importación satisfactoria';
		---
		INSERT 
		INTO	@vtabResponse
		EXEC	dbo.paCliente_Listar;
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
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'paCliente_Importar')
BEGIN
	PRINT 'SP Create : paCliente_Importar';
	PRINT '***'
END
GO