Create database inventario_react;

character set utf8mb4
collate utf8mb4_general_ci;

use inventario_react;

create table if not exists usuarios (
    id int auto_increment primary key,
    nombre varchar(50) not null,
    emai varchar(100) not null unique,
    password varchar(255) not null,
    rol varchar(50) not null default 'admin',
    estado TINYINT(1) not null default 1,
    creado_en timestamp not null default current_timestamp
);

insert into usuarios (id, nombre, email, password, rol, estado, creado_en) 
values (1,'Administrador','admin@inventario.com','$2c$10$2PAK3.8y/Y.m.dlHm3NDRuoM1Jj3JDK.2PCbJ9qMrcywFyQmzVZSe','admin', 1,'2026-10-28 16:40:30');