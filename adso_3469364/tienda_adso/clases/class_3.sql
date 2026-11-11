/*
SEGURIDAD
Clase 3 seguridad bases de datos
objetivo evidenciar que las contraseñas encriptadas (HASH Y SALT) y aplicar 
practicas de seguridad sobre los datos 

1. hash vs cifrado teoria 
2. contraseñas con hash + salt (SHA2)
3. Procedimiento para registrar usuarios, hacer login y cambiar clave 
4. cifrado reversible para datos sencibles (AES)
5. auditroias por trigger 
6. vistas que ocultan datos 
7. usuarios y roles mysql con minimo privilegio (grant / revoke)
8. prevencion se sql inyeccion de consultas
*/
--1 hash vs cifrado para contraseñas 
-- convierte un texto en una huella  loggitud fija
-- no se puede revertir. para validar el loginse calcula 
-- el hash de la clave escrita y se compara con el guardado 
--salt texto aleatorio distinto para cad usuario que mezcla 
--con la clave antes del hash asi dos usuarios con la misma 
--clave tienen distintos hashes y se frustra la redundancia en las tablas 
 
--cifrado de dos vias para datos sensibles que hay que volver a leer 
-- con una llave se cifra y cin la misma llave se descifra

--nunca guarda contraseñas en segundo plano 


--demsotraccion del texto siempre el mismo hash 
select SHA2("clave123",256) as hash hash_1;
select SHA2("clave123",256) as hash hash_2;

--Demostracion utilizanod salt misma clave 
select SHA2(concat("a1bc3", "clave123*"),256) as
hash_usuario_A;
select SHA2(concat("a9y8x7", "clave123*"),256) as
hash_usuario_B;

--Generar un slat aleatorio de 32 caracteres hexadecimal
--mezcla uuid (identificador unico ) + rand() (numero al zar) + la hora con milisegundos y
--tomamos los 32 caracteres del resultado 
--en mysql 8 existe hex(random_bytes (16)) mas robusto pero mariadb no lo tiene 
select left(SHA2(concat(uuid(), rand(), now(6)),256),32) as salt_aleatorio;

/*
2 LO QUE NUNCA HACER CON CONTRASEÑAS (SOLO PARA MOSTRAR EL RIESGO QUE PUEDE SER)
si alguien roba la base de datos o un empleado curioso  consulta la tabla veria las claves de todos
insert into usuarios (...) values (...,"Miclave123", ...); -- ¡MAL!
*/

/*
3. Procedimiento almacenados de autentificacion
-centralizamos logica de seguridad en procedimientos la aplicacion nunca 
toca directamente el hash solo llama a estos procedimientos 
delimiter cambia el fin de la sentencia a // para poder usar ; dentro del procedimiento 
*/
drop procedure if exists registrar_usuario;
drop procedure if exists sp_login_usuario;
drop procedure if exists sp_cambiar_password;

DELIMETER//

--3.1 REGISTRAR USUARIO: valida la politica de 
--contraseñas genera slat y  guarda el hash
 create procedure sp_registrar_usuario(
    in p_nombre_usuario varchar (50),
    in p_email varchar (100),
    in p_password varcahr(100),
    in p_rol varchar (20),
    in p_id_cliente int
 )
begin 
        declare v_slat char (32);

--politica de constraseña minimo de 8 caracteres una mayuscula y un numero
--tiene mayuscula si la clave es igual a su verision en minuscula, no tiene
--se compara en binary por la collection "ci" considera iguales A y a
if char_length(p_password) < 8
or cast(p_password as binary) = cast (lower(p_password) as binary)
or p_password not regexp "[0-9]" then signal  sqlstate "45000"
Set message_text = "la contraeña debe tener minimo 8 caractere una mayuscula y un numero";
end if;
set v_slat = left(SHA2(concat(uuid(), now(6), 256), 32)); --genera un salt aleatrorio de 32 caracteres 

insert into usuarios (id_cliente, nombre_usuario, email, password_hash, slat, rol)
values (p_id_cliente,
p_nombre_usuario,
p_email,
SHA2(concat(v_slat, p_password), 256),-- se guarda el hash no la clave)
v_salt,
p_rol);
end //

--3.2 login compra hashes cuenta intentos fallidos y bloquea al 3 intento
create procedure sp_login(
        in p_nombre_usuario varchar(50),
        in p_password varchar (100),
        out p_resultado varchar  (100)

)
begin 
declare v_id int default null;
declare v_hash char(64); --incriptacion de la contraseña
declare v_salt char (32); --hace que la incriptacion sea diferente si dos usarios tienen la misma contraeña
declare v_bloqueado boolean;
declare v_intentos int;
--si el select no encuentra el usario, no hay error: v_id queda null
declare continue handler for not found set v_id = null

select id_usuario, password_hash, salt, bloqueado, intentos_fallidos
into v_id, v_hash, v_salt, v_bloqueado, v_intentos
from usuarios 
where nombre_usuario = p_nombre_usuario and activo = true;

if v_id is null then 
--mismo mensaje que clave incorrecta no le decimos al atacante si el usuario existe 
set p_resultado = "usario o contraseña incorrectos"

elseif v_bloqueado then 
set p_resultado = "usuario bloqueado, contacte al administrador;"

elseif v_hash = SHA2(concat(v_salt, p_password), 256)
then 
update usuarios 
set intentos_fallidos = 0, ultimo acceso = now()
where id_usuario = v_id;
set p_resultado = "acceso concedido";

else 
update usuarios 
set intentos_fallidos = v_intentos + 1,
bloqueado = (v_intentos +1 >= 3) -- al tercer error se bloquea
where id_usuario  = v_id;
set p_resultado = "usuario o contraseña incorrectos";
end if 
end //

DELIMETER //
--3.3 cambia contraseña: exige la clave actual y genera salt nuevo
create procedure sp_cambiar_password(
        in p_nombre_usuario varchar (50);
        in p_password_actual varchar (100);
        in p_password_nueva varchar (100);
        out p_resultado varchar (100)
)
begin
declare v_salt_nuevo char (32);

if not exists (select 1 from usarios
where nombre_usuario = p_nombre_usuario
and password_hash = SHA2(concat(salt, p_password_actual), 256)) then
set p_resultado = "la contraseña actual no es correcta";
ELSEIF char_length(p_password_nueva) < 8
OR CAST(p_password_nueva as binary) =CAST(LOWLER
(p_password_nueva) AS BINARY)
OR p_password_nueva NOT regexp "[0-9]" THEN 
SET p_resultado = "la nueva contraseña no cumple LA POLITICA"
ELSE 
set v_salt_nuevo = left(SHA2(concat(uuid(), rand(), now
(6)), 256),32);
update usuarios
set salt = v_salt_nuevo,
password_hash = SHA2(concat(v_salt_nuevo, p_password_nueva), 256)
where nombre_usuario = p_nombre_usuario;
set p_resultado = "contraseña actualizada";
end if;
end //
DELIMETER ;