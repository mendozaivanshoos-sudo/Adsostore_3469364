---ejercicio bd
-- DDL = LENGUAJE DE DEFINICION DE DATOS 
/*Son los datos que nos permiten crear modificar  eliminar 
y consultar la estructura de la base de datos no los datos que se utilizan en ella
utilizamos 
-create crear base de datos
alter modificar la estrcutura de las tablas de la base de datos
drop eliminar base de datos o tablas
truncate vaciar un atabla de datos y reinicia el contador de autoincremento 
rename cambair el jombre de una tabla 
*/

---primer punto
create table proveedores (
id_proveedor int not null AUTO_INCREMENT,
nit varchar (225) not null,
razon_social varchar (225) not null,
telefono varchar (11) not null,
email varchar (225) not null,
ciudad varchar (225) not null,
activo_p boolean not null default true,
CONSTRAINT pk_proveedor primary key (id_proveedor),
CONSTRAINT uq_proveedores_nit UNIQUE (nit)
CONSTRAINT uq_proveedores_email UNIQUE(email)
CONSTRAINT uq_proveedores_telefono UNIQUE(telefono)
)engine  = INNODB
---segundo punto
alter table productos
add column id_proveedor int null after nombre,
add CONSTRAINT fk_productos_proveedores FOREIGN key (id_proveedor) 
REFERENCES proveedores (id_proveedor)
on DELETE set null;
--- tercer punto
create table direcciones_envio(
    id_direccion int primary key not null,
    id_cliente int null,
    direccion varchar (225) not null,
    ciudad varchar (225) not null,
    barrio varchar (255) not null,
    es_principal boolean not null default false,
    CONSTRAINT fk_direccion_envio_clientes FOREIGN key (id_cliente)
    REFERENCES clientes (id_cliente)
    on delete CASCADE
    ) engine = INNODB;
--- cuarto punto
alter table productos
add CONSTRAINT ck_productos_precio_max check (precio<=50000000);
--- quinto punto 
create index idx_clientes_ciudad on clientes (ciudad);
---sexto punto 
create table tabla_pruebas(
 id_prueba int not null AUTO_INCREMENT,
 pruebas_old varchar (225) null,
CONSTRAINT pk_tabla_pruebas PRIMARY key (id_prueba)
) engine = INNODB
rename table tabla_pruebas to pruebas_old
drop table pruebas_old;
show tables;