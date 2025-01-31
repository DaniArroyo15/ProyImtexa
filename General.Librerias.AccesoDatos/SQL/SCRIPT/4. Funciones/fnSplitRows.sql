CREATE FUNCTION fnSplitStringRows  
(  
@Cadena nVarchar(MAX)  
    ,@SeparadorFila Varchar(2)  
,@SeparadorColumna Varchar(2)  
)   
RETURNS @TablaTemp TABLE(Campo1 nVarchar(3000), Campo2 nVarchar(3000),  
Campo3 nVarchar(3000), Campo4 nVarchar(3000),  
Campo5 nVarchar(3000), Campo6 nVarchar(3000),  
Campo7 nVarchar(3000), Campo8 nVarchar(3000),  
Campo9 nVarchar(3000), Campo10 nVarchar(3000),  
Campo11 nVarchar(3000), Campo12 nVarchar(3000),  
Campo13 nVarchar(3000), Campo14 nVarchar(3000),  
Campo15 nVarchar(3000), Campo16 nVarchar(3000),  
Campo17 nVarchar(3000), Campo18 nVarchar(3000),  
Campo19 nVarchar(3000), Campo20 nVarchar(3000))   
As  
Begin   
Declare @Campo1 nVarchar(3000), @Campo2 nVarchar(3000),  
@Campo3 nVarchar(3000), @Campo4 nVarchar(3000),  
@Campo5 nVarchar(3000), @Campo6 nVarchar(3000),  
@Campo7 nVarchar(3000), @Campo8 nVarchar(3000),  
@Campo9 nVarchar(3000), @Campo10 nVarchar(3000),  
@Campo11 nVarchar(3000), @Campo12 nVarchar(3000),  
@Campo13 nVarchar(3000), @Campo14 nVarchar(3000),  
@Campo15 nVarchar(3000), @Campo16 nVarchar(3000),  
@Campo17 nVarchar(3000), @Campo18 nVarchar(3000),  
@Campo19 nVarchar(3000), @Campo20 nVarchar(3000),  
@CadenaCampo nVarchar(MAX),  
@FilInicio Int, @FilFin Int, @FilLongitud Int,  
@ColInicio Int, @ColFin Int, @ColLongitud Int, @ColPosicion Int, @ColCampo nVarchar(max)  
--  
Select @FilLongitud = Len(@Cadena), @FilInicio = 1, @FilFin = CharIndex(@SeparadorFila, @Cadena)   
    WHILE @FilInicio < @FilLongitud + 1   
Begin   
        IF @FilFin = 0  
Begin  
SET @FilFin = @FilLongitud + 1  
End  
--  
--Pintando Columnas  
Set @CadenaCampo = SubString(@Cadena, @FilInicio, @FilFin - @FilInicio)  
Set @CadenaCampo += @SeparadorColumna  
Select @ColLongitud = Len(@CadenaCampo), @ColInicio = 1, @ColFin = CharIndex(@SeparadorColumna, @CadenaCampo), @ColPosicion = 1  
WHILE @ColInicio < @ColLongitud + 1   
Begin   
IF @ColFin = 0  
Begin  
SET @ColFin = @ColLongitud + 1  
End  
--  
Set @ColCampo = SubString(@CadenaCampo, @ColInicio, @ColFin - @ColInicio)  
if @ColPosicion = 1  
Set @Campo1 = @ColCampo  
else if @ColPosicion = 2  
Set @Campo2 = @ColCampo  
else if @ColPosicion = 3  
Set @Campo3 = @ColCampo  
else if @ColPosicion = 4  
Set @Campo4 = @ColCampo  
else if @ColPosicion = 5  
Set @Campo5 = @ColCampo  
else if @ColPosicion = 6  
Set @Campo6 = @ColCampo  
else if @ColPosicion = 7  
Set @Campo7 = @ColCampo  
else if @ColPosicion = 8  
Set @Campo8 = @ColCampo  
else if @ColPosicion = 9  
Set @Campo9 = @ColCampo  
else if @ColPosicion = 10  
Set @Campo10 = @ColCampo  
else if @ColPosicion = 11  
Set @Campo11 = @ColCampo  
else if @ColPosicion = 12  
Set @Campo12 = @ColCampo  
else if @ColPosicion = 13  
Set @Campo13 = @ColCampo  
else if @ColPosicion = 14  
Set @Campo14 = @ColCampo  
else if @ColPosicion = 15  
Set @Campo15 = @ColCampo  
else if @ColPosicion = 16  
Set @Campo16 = @ColCampo  
else if @ColPosicion = 17  
Set @Campo17 = @ColCampo  
else if @ColPosicion = 18  
Set @Campo18 = @ColCampo  
else if @ColPosicion = 19  
Set @Campo19 = @ColCampo  
else if @ColPosicion = 20  
Set @Campo20 = @ColCampo  
--  
SET @ColInicio = @ColFin + 1   
SET @ColFin = CharIndex(@SeparadorColumna, @CadenaCampo, @ColInicio)  
Set @ColPosicion += 1  
End   
--  
Insert Into @TablaTemp( Campo1, Campo2, Campo3, Campo4, Campo5, Campo6, Campo7, Campo8, Campo9, Campo10,  
Campo11, Campo12, Campo13, Campo14, Campo15, Campo16, Campo17, Campo18, Campo19, Campo20)  
Values ( @Campo1, @Campo2, @Campo3, @Campo4, @Campo5, @Campo6, @Campo7, @Campo8, @Campo9, @Campo10,  
@Campo11, @Campo12, @Campo13, @Campo14, @Campo15, @Campo16, @Campo17, @Campo18, @Campo19, @Campo20)  
--  
SET @FilInicio = @FilFin + 1   
SET @FilFin = CharIndex(@SeparadorFila, @Cadena, @FilInicio)  
    End   
    Return   
End  




