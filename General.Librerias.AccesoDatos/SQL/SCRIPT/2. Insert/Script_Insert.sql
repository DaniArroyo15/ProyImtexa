
-- MÓDULOS --

INSERT dbo.Sistema_Modulo
(vNombre, dFechaRegistro, vUsuarioRegistro, vIdPcRegistro, dFechaActualiza, vUsuarioActualiza, vIdPcActualiza, bActivo)
SELECT 'Administración',GETDATE(),'DARROYO','11',GETDATE(),'','',1 
INSERT dbo.Sistema_Modulo
(vNombre, dFechaRegistro, vUsuarioRegistro, vIdPcRegistro, dFechaActualiza, vUsuarioActualiza, vIdPcActualiza, bActivo)
SELECT 'Almacén',GETDATE(),'DARROYO','11',GETDATE(),'','',1 
INSERT dbo.Sistema_Modulo
(vNombre, dFechaRegistro, vUsuarioRegistro, vIdPcRegistro, dFechaActualiza, vUsuarioActualiza, vIdPcActualiza, bActivo)
SELECT 'Contable',GETDATE(),'DARROYO','11',GETDATE(),'','',1 
INSERT dbo.Sistema_Modulo
(vNombre, dFechaRegistro, vUsuarioRegistro, vIdPcRegistro, dFechaActualiza, vUsuarioActualiza, vIdPcActualiza, bActivo)
SELECT 'Ventas',GETDATE(),'DARROYO','11',GETDATE(),'','',1 


-- OPCIÓN --

INSERT Sistema_Opcion
(eIdModulo, eIdOpcionPadre, vNombre, vRuta, vIcon, vNuOrden, dFechaRegistro, vUsuarioRegistro, vIdPcRegistro, dFechaActualiza, vUsuarioActualiza, vIdPcActualiza, bActivo)
SELECT 2, 0,'CATÁLOGO', '', 'fa-snowflake-o','', GETDATE(),'DARROYO','127.0', GETDATE(), '', '', '1'
INSERT Sistema_Opcion
(eIdModulo, eIdOpcionPadre, vNombre, vRuta, vIcon, vNuOrden, dFechaRegistro, vUsuarioRegistro, vIdPcRegistro, dFechaActualiza, vUsuarioActualiza, vIdPcActualiza, bActivo)
SELECT 2, 1,'CATEGORIA', 'Almacen/Almacen/Categoria', 'fa-snowflake-o','1', GETDATE(),'DARROYO','127.0', GETDATE(), '', '', '1'
INSERT Sistema_Opcion
(eIdModulo, eIdOpcionPadre, vNombre, vRuta, vIcon, vNuOrden, dFechaRegistro, vUsuarioRegistro, vIdPcRegistro, dFechaActualiza, vUsuarioActualiza, vIdPcActualiza, bActivo)
SELECT 2, 1,'PRODUCTOS', 'Almacen/Almacen/Producto', 'fa-snowflake-o', '2', GETDATE(),'DARROYO','127.0', GETDATE(), '', '', '1'


--Administración 
INSERT Sistema_Opcion
(eIdModulo, eIdOpcionPadre, vNombre, vRuta, vIcon, vNuOrden, dFechaRegistro, vUsuarioRegistro, vIdPcRegistro, dFechaActualiza, vUsuarioActualiza, vIdPcActualiza, bActivo)
SELECT 1, 0,'ADMINISTRACIÓN', '', 'desktop','', GETDATE(),'DARROYO','127.0', GETDATE(), '', '', '1'
INSERT Sistema_Opcion
(eIdModulo, eIdOpcionPadre, vNombre, vRuta, vIcon, vNuOrden, dFechaRegistro, vUsuarioRegistro, vIdPcRegistro, dFechaActualiza, vUsuarioActualiza, vIdPcActualiza, bActivo)
SELECT 1, 5,'PERSONAS', 'Personal/Persona/Index', 'user-plus','1', GETDATE(),'DARROYO','127.0', GETDATE(), '', '', '1'


-- CATALOGO --

INSERT Sistema_Catalogo
(eIdCatalogoPadre, eIdGrupo, vDescripcion, dFechaRegistro, vUsuarioRegistro, vIdPcRegistro, dFechaActualiza, vUsuarioActualiza, vIdPcActualiza, bActivo)
SELECT 0,1,'TIPO DE PERSONA',GETDATE(),'DARROYO','127.0',GETDATE(),'','','1'
INSERT Sistema_Catalogo
(eIdCatalogoPadre, eIdGrupo, vDescripcion, dFechaRegistro, vUsuarioRegistro, vIdPcRegistro, dFechaActualiza, vUsuarioActualiza, vIdPcActualiza, bActivo)
SELECT 1,1,'NATURAL',GETDATE(),'DARROYO','127.0',GETDATE(),'','','1'
INSERT Sistema_Catalogo
(eIdCatalogoPadre, eIdGrupo, vDescripcion, dFechaRegistro, vUsuarioRegistro, vIdPcRegistro, dFechaActualiza, vUsuarioActualiza, vIdPcActualiza, bActivo)
SELECT 1,1,'JURIDICA',GETDATE(),'DARROYO','127.0',GETDATE(),'','','1'
-- Genero
INSERT Sistema_Catalogo
(eIdCatalogoPadre, eIdGrupo, vDescripcion, dFechaRegistro, vUsuarioRegistro, vIdPcRegistro, dFechaActualiza, vUsuarioActualiza, vIdPcActualiza, bActivo)
SELECT 0,2,'GENERO',GETDATE(),'DARROYO','127.0',GETDATE(),'','','1'
INSERT Sistema_Catalogo
(eIdCatalogoPadre, eIdGrupo, vDescripcion, dFechaRegistro, vUsuarioRegistro, vIdPcRegistro, dFechaActualiza, vUsuarioActualiza, vIdPcActualiza, bActivo)
SELECT 4,2,'MASCULINO',GETDATE(),'DARROYO','127.0',GETDATE(),'','','1'
INSERT Sistema_Catalogo
(eIdCatalogoPadre, eIdGrupo, vDescripcion, dFechaRegistro, vUsuarioRegistro, vIdPcRegistro, dFechaActualiza, vUsuarioActualiza, vIdPcActualiza, bActivo)
SELECT 4,2,'FEMENINO',GETDATE(),'DARROYO','127.0',GETDATE(),'','','1'



-- PERSONA --

INSERT General_Persona
(eIdCatalogo, vDni, vNombre, vApellidoPaterno, vApellidoMaterno, vIdCataSexo, vTelefono, vCorreo, vDireccion, vArchivoFoto, dFechaRegistro, vUsuarioRegistro, vIdPcRegistro,
dFechaActualiza, vUsuarioActualiza, vIdPcActualiza, bActivo)
SELECT 2,'10203040','DANIEL','ARROYO','ALVARADO','5','999888777','DARROYO@GMAIL.COM','AV SERGIO 125','',GETDATE(),'DARROYO','127.0',GETDATE(),'','','1'
INSERT General_Persona
(eIdCatalogo, vDni, vNombre, vApellidoPaterno, vApellidoMaterno, vIdCataSexo, vTelefono, vCorreo, vDireccion, vArchivoFoto, dFechaRegistro, vUsuarioRegistro, vIdPcRegistro,
dFechaActualiza, vUsuarioActualiza, vIdPcActualiza, bActivo)
SELECT 2,'10203043','ERICK','LUCIANI','CACERES','5','999888777','ELUCIANI@GMAIL.COM','AV SERGIO 124','',GETDATE(),'DARROYO','127.0',GETDATE(),'','','1'
INSERT General_Persona
(eIdCatalogo, vDni, vNombre, vApellidoPaterno, vApellidoMaterno, vIdCataSexo, vTelefono, vCorreo, vDireccion, vArchivoFoto, dFechaRegistro, vUsuarioRegistro, vIdPcRegistro,
dFechaActualiza, vUsuarioActualiza, vIdPcActualiza, bActivo)
SELECT 2,'10203041','CARLOS','CALLAGUA','TORRES','5','999888777','CCALLAGUA@GMAIL.COM','AV SERGIO 123','',GETDATE(),'DARROYO','127.0',GETDATE(),'','','1'
INSERT General_Persona
(eIdCatalogo, vDni, vNombre, vApellidoPaterno, vApellidoMaterno, vIdCataSexo, vTelefono, vCorreo, vDireccion, vArchivoFoto, dFechaRegistro, vUsuarioRegistro, vIdPcRegistro,
dFechaActualiza, vUsuarioActualiza, vIdPcActualiza, bActivo)
SELECT 2,'10203042','JAER','BERNACHEA','TORRES','5','999888777','JBERNACHEA@GMAIL.COM','AV SERGIO 126','',GETDATE(),'DARROYO','127.0',GETDATE(),'','','1'



-- USUARIO --

INSERT Seguridad_Usuario
(eIdPersona, vUsuario, vClave, dFechaRegistro, vUsuarioRegistro, vIdPcRegistro, dFechaActualiza, vUsuarioActualiza, vIdPcActualiza, bActivo)
SELECT 1,'DARROYO','ADMIN',GETDATE(),'DARROYO','',GETDATE(),'','','1'



-- PERFIL --

INSERT Seguridad_Perfil
(vNombre, dFechaRegistro, vUsuarioRegistro, vIdPcRegistro, dFechaActualiza, vUsuarioActualiza, vIdPcActualiza, bActivo)
SELECT 'SUPER ADMI',GETDATE(),'DARROYO','',GETDATE(),'','','1'
INSERT Seguridad_Perfil
(vNombre, dFechaRegistro, vUsuarioRegistro, vIdPcRegistro, dFechaActualiza, vUsuarioActualiza, vIdPcActualiza, bActivo)
SELECT 'ADMINISTRADOR',GETDATE(),'DARROYO','',GETDATE(),'','','1'



-- USUARIO X PERFIL --

INSERT Seguridad_UsuarioPerfil
(eIdPerfil,eIdUsuario,dFechaRegistro, vUsuarioRegistro,vIdPcRegistro, dFechaActualiza, vUsuarioActualiza, vIdPcActualiza, bActivo)
SELECT 1,1,GETDATE(),'DARROYO','',GETDATE(),'','','1'


-- OPCIÓN X USUARIO --

INSERT Seguridad_OpcionUsuario
(eIdOpcion, eIdUsuario, bVer, bNuevo, bEditar, bGuardar, bEliminar, bImprimir, bExportar, dFechaRegistro, vUsuarioRegistro, vIdPcRegistro, dFechaActualiza, vUsuarioActualiza, vIdPcActualiza, bActivo)
SELECT 1, 1, '1','1','1','1','1','1','1', GETDATE(), 'DARROYO', '127.0',GETDATE(),'','','1' 
INSERT Seguridad_OpcionUsuario
(eIdOpcion, eIdUsuario, bVer, bNuevo, bEditar, bGuardar, bEliminar, bImprimir, bExportar, dFechaRegistro, vUsuarioRegistro, vIdPcRegistro, dFechaActualiza, vUsuarioActualiza, vIdPcActualiza, bActivo)
SELECT 2, 1, '1','1','1','1','1','1','1', GETDATE(), 'DARROYO', '127.0',GETDATE(),'','','1' 
INSERT Seguridad_OpcionUsuario
(eIdOpcion, eIdUsuario, bVer, bNuevo, bEditar, bGuardar, bEliminar, bImprimir, bExportar, dFechaRegistro, vUsuarioRegistro, vIdPcRegistro, dFechaActualiza, vUsuarioActualiza, vIdPcActualiza, bActivo)
SELECT 3, 1, '1','1','1','1','1','1','1', GETDATE(), 'DARROYO', '127.0',GETDATE(),'','','1' 
INSERT Seguridad_OpcionUsuario
(eIdOpcion, eIdUsuario, bVer, bNuevo, bEditar, bGuardar, bEliminar, bImprimir, bExportar, dFechaRegistro, vUsuarioRegistro, vIdPcRegistro, dFechaActualiza, vUsuarioActualiza, vIdPcActualiza, bActivo)
SELECT 4, 1, '1','1','1','1','1','1','1', GETDATE(), 'DARROYO', '127.0',GETDATE(),'','','1' 

-- Administración
select * from Sistema_Opcion

INSERT Seguridad_OpcionUsuario
(eIdOpcion, eIdUsuario, bVer, bNuevo, bEditar, bGuardar, bEliminar, bImprimir, bExportar, dFechaRegistro, vUsuarioRegistro, vIdPcRegistro, dFechaActualiza, vUsuarioActualiza, vIdPcActualiza, bActivo)
SELECT 5, 1, '1','1','1','1','1','1','1', GETDATE(), 'DARROYO', '127.0',GETDATE(),'','','1' 
INSERT Seguridad_OpcionUsuario
(eIdOpcion, eIdUsuario, bVer, bNuevo, bEditar, bGuardar, bEliminar, bImprimir, bExportar, dFechaRegistro, vUsuarioRegistro, vIdPcRegistro, dFechaActualiza, vUsuarioActualiza, vIdPcActualiza, bActivo)
SELECT 6, 1, '1','1','1','1','1','1','1', GETDATE(), 'DARROYO', '127.0',GETDATE(),'','','1' 
GO