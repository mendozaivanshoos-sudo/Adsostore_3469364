/*
*auditoria trigger que registra eventos de seguridad insert, update, o delete sobre la tabla 
guardamos quien y cuando cambio una clave o se bloquea el usuario 
nunca se daña la contraseña en la auditoria
*/
create table if not exists auditoria_usuarios(
    id_auditoria int auto_increment primary key,
    id_usuario int not null,
    accion varchar(30) not null,
    detalle varchar(255) null,
    usuario_bd varchar(100) not null, -- usuario de mysql que hizo cambio 
    fecha datetime not null default 
    current_timestamp
) engine = innoDB;
DROP trigger if exists trg_usuarios_auditoria

DELIMITER //
create trigger trg_usuarios_auditoria
AFTER update on usuarios 
for each row
begin 

if NEW.password_hash <> OLD.password_hash 
then
insert into auditoria_usuarios(id_usuario,
accion, detalle, usuario_bd)
values (NEW.id_usuario, 'CAMBIO_PASSWORD','se cambio la contraseña', current_user());
end iF;

IF NEW.bloqueado = TRUE AND OLD.bloqueado = false then
insert into auditoria_usuarios(id_usuario, accion, detalle, usuario_bd)
values (NEW.id_usuario, 'bloqueado','bloqueado por 3 intentos fallidos ', current_user());
end if;
end//

DELIMITER ;

/*
* PROBAR registro login bloqueo y cambio de clave 
--registrar usuarios (las claves solo viajan como parametroy nunca se guardan )
*/
call sp_registrar_usuario('admin','admin@tienda.com', 'Admin*2026seguro', 'ADMIN', NULL);
call sp_registrar_usuario('vendedor','ventas@tienda.com', 'Ventas#2026', 'VENDEDOR', NULL);

call sp_registrar_usuario('ana.gomez','ana.gomez@tienda.com', 'Anagomez2026', 'CLIENTE', 1);
call sp_registrar_usuario('corlos.perez','carlos.perez@tienda.com', 'Carlos2026', 'CLIENTE', 2);
call sp_registrar_usuario('debil','debil@tienda.com', '12345', 'CLIENTE', null); --- lo debe rechazar por tener una contraseña debil

/*
la contraseña no se ve e texto plano solo el hash y el salt
*/
select id_usuario, nombre_usuario, rol salt, password_hash
from usuarios;

/*login correcto*/
call sp_login ('ana.gomez', 'anagomez2026', @resultado);
select @resultado as login_correcto;

/*
tres intentos fallidos = bloqueo
*/
 call sp_login('carlos.perez','clave mala', @r1);
  call sp_login('carlos.perez','clave mala', @r2);
   call sp_login('carlos.perez','clave mala', @r3);
    call sp_login('carlos.perez','carlos2026', @r4); --aunque ahora sea correcta el usuario esta bloqueado
select @r1, @r2, @r3, @r4;

select nombre_usuario, intentos_fallidos, bloqueado, from usuarios;
--- cambio de contraseña 
call sp_login_password('ana.gomez', 'anagomez2026', 'nuevaclave2026', @r);
select @r as cambio;

--evidencia de auditoria: aparecen el bloqueo y cambio de clave 
select * from auditoria_usuarios;
--el administrador se desbloquea el usuario
update usuarios set bloqueado = false = 0 
where nombre_usuario = 'carlos.perez';