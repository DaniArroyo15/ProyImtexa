CREATE FUNCTION [dbo].[fnSplitStringTable]   
(   
    @pvstring NVARCHAR(MAX),   
    @pvdelimiter CHAR(1)   
)   
RETURNS @pvoutput TABLE(Nro INT,splitdata NVARCHAR(MAX)   
)   
BEGIN   
DECLARE @veCont INT = 0;  
    DECLARE @vestart INT, @veend INT   
    SELECT @vestart = 0, @veend = CHARINDEX(@pvdelimiter, @pvstring)   
    WHILE @vestart < LEN(@pvstring) + 2 BEGIN   
        IF @veend = 0    
            SET @veend = LEN(@pvstring) + 1  
        INSERT INTO @pvoutput (Nro, splitdata)    
        VALUES(@veCont,RTRIM(LTRIM(SUBSTRING(@pvstring, @vestart, @veend - @vestart)) ))  
SET @veCont = @veCont + 1;  
        SET @vestart = @veend + 1   
        SET @veend = CHARINDEX(@pvdelimiter, @pvstring, @vestart)  
    END   
    RETURN  
END  