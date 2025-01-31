--USE BD_SISMA
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==========================================================================================================================
-- Proyecto Sisma
-- Fecha Creación	:	
-- Descripcion		:	Funcion Split Table para los parametros de ingreso y salida (Tablas)
-- Responsable		:	Guillermo Zambrano
-- Nro Entregable	:	
-- Observacion		:	
-- ==========================================================================================================================
/*
	SELECT * FROM dbo.fnSplitStringTable('||6|','|');
*/
CREATE FUNCTION [dbo].[fnSplitStringTable] 
( 
    @pvcString		NVARCHAR(MAX), 
    @pvcDelimiter	CHAR(1) 
) 
RETURNS @ptaboutput TABLE(Nro INT,splitdata NVARCHAR(MAX) 
) 
BEGIN 
	DECLARE @veCont INT = 0;
    DECLARE @vestart INT, @veend INT 
    SELECT @vestart = 0, @veend = CHARINDEX(@pvcDelimiter, @pvcString) 
    WHILE @vestart < LEN(@pvcString) + 2 BEGIN 
        IF @veend = 0  
            SET @veend = LEN(@pvcString) + 1
       
        INSERT INTO @ptaboutput (Nro, splitdata)  
        VALUES(@veCont,RTRIM(LTRIM(SUBSTRING(@pvcString, @vestart, @veend - @vestart)) ))
		SET @veCont = @veCont + 1;
        SET @vestart = @veend + 1 
        SET @veend = CHARINDEX(@pvcDelimiter, @pvcString, @vestart)
    END 
    RETURN
END
GO
IF EXISTS (SELECT * FROM sys.sql_modules AS sm WHERE sm.object_id = OBJECT_ID('dbo.fnSplitStringTable'))
BEGIN
	PRINT 'Function Alter : fnSplitStringTable';
    --SELECT * FROM dbo.fnSplitStringTable('1-2-3-4-5-6-7','-');
END
GO

