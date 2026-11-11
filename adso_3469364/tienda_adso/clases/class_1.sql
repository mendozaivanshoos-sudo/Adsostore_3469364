--comandos codigos elimar base de datos existente--
drop DATABASE if EXISTS
--code regional/aceptar caracterees especiales--
CHARACTER set utf8mb4
COLLATE utf8mb4_unicode_ci;
#crear base de datos
create database
-------------------------------
#para trabajar solo en la base de datos
use
--------------------------------
--estructura/condiciones/fecha hora del sistema/ llave foranea --
use tienda_adso;
create table categorias(
   id_categoria int not null AUTO_INCREMENT,
    nombre varchar(50) not null,
    descripcion varchar(255) null,
    CONSTRAINT pk_categorias PRIMARY key (id_categoria),
    CONSTRAINT uq_categorias_nombre UNIQUE (nombre)
) ENGINE = INNODB;

create table productos (
  id_producto int not null AUTO_INCREMENT,
    id_categoria int not null,
    nombre varchar(50) not null,
    precio decimal (12,2) not null,
    stock int  not null  DEFAULT 0,
    activo boolean not null default true,
    fecha_registro datetime not null DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_producto PRIMARY key (id_producto),
    CONSTRAINT ck_productos_precio CHECK (precio>0),
    CONSTRAINT ck_productos_stock CHECK (precio>=0),
      CONSTRAINT fk_productos_categorias FOREIGN key (id_categoria)
    REFERENCES categorias (id_categoria)
    on DELETE RESTRICT
    on update cascade 
    ) engine  = INNODB
    -----------------------------------


    -- campos dispo para tipo de documento
    use tienda_adso;
create table clientes(
    id_cliente int not null AUTO_INCREMENT,
    tipo_documento varchar (50) not null DEFAULT "cc",
    numero_documento varchar (10) not null,
    nombre_cliente varchar(20) not null,
    apellido_cliente varchar (20) not null,
    email varchar (50) not null,
    telefono varchar (10) not null,
    ciudad varchar (50) null,
    fecha_registro datetime not null DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_cliente PRIMARY key (id_cliente),
     CONSTRAINT uq_clientes_numero_docuemnto UNIQUE (numero_documento),
     CONSTRAINT uq_clientes_email UNIQUE (email),
    
    CONSTRAINT ck_clientes_tipo_documento CHECK (tipo_documento in ("cc", "ti", "ce", "pass")) 
    ) ENGINE = INNODB;
    create table pedidos(
    id_pedido int not null AUTO_INCREMENT,
    id_cliente int not null,
    fecha_pedido datetime not null DEFAULT CURRENT_TIMESTAMP,
    estado varchar (20) not null DEFAULT ("pendiente"),
    total varchar (50) not null DEFAULT 0,
    CONSTRAINT pk_pedidos PRIMARY key (id_pedido),
     CONSTRAINT ck_pedidos_estado check (estado in ("pendiente","pagado", "enviado", "cancelado")),
     CONSTRAINT ck_pedidos_total CHECK (total>0),
    CONSTRAINT fk_pedidos_clientes FOREIGN key (id_cliente)
    REFERENCES clientes (id_cliente)
    on DELETE RESTRICT
    on UPDATE CASCADE
    ) ENGINE = INNODB;

   create table detalle_pedidos(
    id_detalle int not null AUTO_INCREMENT,
    id_pedido int not null,
    id_producto int not null,
    cantidad varchar (200) not null DEFAULT 0,
    precio decimal (12,2) not null,
    
   
    CONSTRAINT pk_detalle PRIMARY key (id_detalle),
    CONSTRAINT uq_detalle_pedidos_producto UNIQUE (id_pedido, id_producto),    
    
     CONSTRAINT ck_detalle_cantidad check (cantidad>0),
     CONSTRAINT ck_detalle_precio CHECK (precio>0),
    
     CONSTRAINT fk_productos_detalle_pedidos FOREIGN key (id_producto)
     REFERENCES productos(id_producto)
    on DELETE CASCADE,
    CONSTRAINT fk_pedidos_detalle_clientes FOREIGN key (id_pedido)
    REFERENCES pedidos (id_pedido)
    on DELETE RESTRICT
    ) ENGINE = INNODB;


    ---salt cambia la incriptacion de la contraseña junto al hash si la contraseña es la misma---
   create table usuarios(
    id_usuario int not null AUTO_INCREMENT,
    id_cliente int null,
    nombre_usuario varchar (50),
    email varchar (50),
    password_hash char (64) not null,
    salt char (32) not null,
    rol varchar (20)not null DEFAULT "cliente",
    activo boolean not null DEFAULT true,
    intentos_fallidos int NOT null DEFAULT 0,
    bloqueado boolean not null DEFAULT false,
    ultimo_acceso datetime  null,
    fecha_creacion datetime not null DEFAULT
    CURRENT_TIMESTAMP,
    CONSTRAINT pk_usuarios PRIMARY key (id_usuario),
    CONSTRAINT uq_usuarios_nombre UNIQUE (nombre_usuario),
    CONSTRAINT uq_usuarios_email UNIQUE (email),
    CONSTRAINT ck_usuarios_rol check (rol in ("admin","vendedor","cliente")),
    CONSTRAINT fk_usuarios_clientes FOREIGN key (id_cliente)
    REFERENCES clientes (id_cliente)
    on DELETE set null
    )engine = INNODB
    --------------------------------------------


    --PARA MIRAR LAS TABLAS--
    SHOW TABLES;
    ------------------------
    --PARA SABER LA DESCRIPCION DE UNA TABLA---
    DESCRIBE productos;
    ------------------------
    --para mostrar el codigo de la tabla---
    SHOW CREATE TABLE pedidos;
    ------------------------
  ---para crear el diccionario de datos---
  SELECT TABLE_NAME, CONSTRAINT_name, CONSTRAINT_type
from information_schema.table_CONSTRAINTS
where table_schema = "tienda_adso"
order by table_name, CONSTRAINT_type;
--------------------------------------------
---agregar una columna a una tabla existente---
alter table clientes 
add column fecha_nacimiento date null after apellidos;
----cambiar tipo de dato a una columna existente 
alter table  clientes
modify column telefono varchar(50) null;
-------------------------------------------
---renombrar una columna change column pide nombre viejo
--nuevo nombre
--y la definicion de la columna completa 
alter table clientes 
change column ciudad ciudad_recidencia varchar (50)
 not null;
 ---eliminar una columna de la tabla
 alter table clientes
 drop column fecha_nacimiento;
 ------------------------------------
 -- agregar una descripcion a una tabla
 alter table productos 
 add CONSTRAINT uq_producto_nombre UNIQUE (nombre);
 ---------------------------------------
 --eliminar una restriccion a una tabla existente
 alter table productos
 drop index  uq_producto_nombre;
 -----------------------------------------
 --crear indices para busquedas mas rapidas 
 create index idx_productos_nombre on productos (nombre);
  create index idx_pedidos_fecha on pedidos (fecha_pedido);
   create index idx_clientes_apellidos on clientes (apellido, nombre);
---mirar los indices de una tabla---
show index from productos;
------------------------------
create table tabla_practica(
id_practica int not null AUTO_INCREMENT,

detalle varchar(225) not null,
   CONSTRAINT pk_detalle primary key (id_practica)
) ENGINE = INNODB
---INSERTAR DATOS EN LA TABLA PRACTICA
insert into tabla_practica (detalle) values ("fila 1"), ("fila 2");
---borrar todas las filas de golpe y reinicia el auto incremnt
truncate table tabla_practica;
----cambiar el nombre de una tabla
rename table tabla_practica to tabla_borrar
--- eliminar tabla
drop table tabla_borrar;

