---DML CLASE
---El DML nos permite manioular la base datos en 4 acciones 
---crear, consultar, modificar, elimnar
---va a realizar consultas con select con filtros orden y limites 
---joins (inner, left, right, full emulado)
---agregaciones por count sum avs min max group by, having
--.subconsultas 
--insertar datos de prueba y verificar que existen 
-- DML = LENGUAJE DE MANIPULACION DE DATOS

/* insertar datos de prueba (CRUD c=crear)
si se insertan datos en una tabla se debe tener en cuenta el orden de los campos, 
el tipo de campo y la llave foranea
*/ 
insert into categorias (nombre, descripcion) 
 values ("tecnologia", "computadores , perifericos, accesorios");


insert into categorias (nombre, descripcion) 
 values 
("hogar", "electrodomesticos , articulos para el hogar"),
  ("papeleria","utiles escolares"),
  ("deporte","implementos deportivos"),
  ("juguetes","aun sin productos");
  /*insertar datos en una tabla con relacion */
 insert into productos (id_categoria, nombre, precio,stock)
  values 
  (1,"portatil lenovo ideapad",2500000,15),
  (1, "mouse inalambrico", 45000, 120),
  (1,"teclado mecanico", 180000,40),
  (1, "monitor 24 pulgadas", 650000,25),
  (2, "licuadora oster", 220000, 30),
  (2, "juego de ollas", 310000, 18),
  (2, "lampara led", 60000, 75),
  (3,"cuaderno 100 hojas", 8500,500),
  (3,"resma papel carta", 22000,200),
  (3,"kit de marcadores", 15000,150),
  (4,"balon futbol", 85000,60),
  (4,"bicicleta estatica", 1200000,5);

  insert into clientes (tipo_documento,numero_documento, nombre_cliente, 
  apellido_cliente, email, telefono, ciudad)
  values
  ("cc","1001001001","ana maria","gomez ruiz",
  "ana.gomez@correo.com","3001112233","medellin"),

("cc","1002002002","carlos andres","perez diaz",
  "carlos.perez@correo.com","3002223344","bogota"),

  ("cc","1003003003","luisa fernanda","martinez rios",
  "luisa.martinez@correo.com","3023334455","cali"),

  ("ti","1004004004","juan david","restrepo toro",
  "juan.restrepo@correo.com","3004445566","medellin"),

  ("ce","1005005005","valentina","herrera lopez",
  "valentina.herrera@correo.com","3045556677","barranquilla"),

  ("cc","1006006006","santiago","ramirez castro",
  "santiago.ramirez@correo.com","3056667788","bogota"),

  ("cc","1007007007","daniela","ospina vargas",
  "daniela.ospina@correo.com","3067778899","medellin"),

  ("cc","1008008008","mateo","londoño giraldo",
  "mateo.londoño@correo.com","null","pereira");


/*
ajuste de tabla pedidos
*/

alter table pedidos modify column total decimal (12,2) not null
default 0;

alter table pedidos drop CONSTRAINT if exists ck_pedidos_total;

ALTER TABLE pedidos ADD CONSTRAINT ck_pedidos_total check (total>=0);

/* pedidos vamos a realizar un insert con 1 relacion 
con cliente
*/

insert into pedidos (id_cliente,fecha_pedido,estado)
values
(1,"2026-08-01 10:15:00", "pagado"),
(2,"2026-08-03 14:30:00", "enviado"),
(1,"2026-08-10 09:15:00", "enviado"),
(3,"2026-08-15 16:45:00", "pagado"),
(4,"2026-08-20 11:20:00", "cancelado"),
(5,"2026-09-02 08:10:00", "pendiente"),
(6,"2026-09-05 19:00:00", "pagado"),
(2,"2026-09-12 12:00:00", "pagado"),
(7,"2026-09-20 17:30:00", "enviado"),
(1,"2026-09-28 10:05:00", "pendiente");

/*
detalle de pedidos se maneja con 2 relaciones 
con productos  y pedidos
*/

insert into detalle_pedidos (id_pedido, id_producto, cantidad, precio)
values 
(1,1,1, 2500000), (1,2,2, 45000),
(2,4,2, 650000), (2,3,1, 45000),
(3,8,10, 8500), (3,9,2, 45000),
(4,5,1, 220000), (4,7,2,60000),
(5,11,1, 8500),
(6,6,1, 310000), (6,2,2, 45000),
(7,1,1, 2500000), (7,4,1, 650000), (7,2,1, 45000),
(8,10,5, 15000), (8,8,20, 8500),
(9,3,2, 180000), (9,7,1, 60000),
(10,11,2, 2500000), (10,9,3, 220000);

/* TRABAJO CON LOS DATOS DE UNA BASE DE 
DATOS CALCULAR EL TOTAL DE CADA PEDIDO CON UPDATE + CONSULTA CORELACIONADA
PARA CADA PEDIDO "P" SUMA CANTIDAD "PRECIO DETALLES"
*/

UPDATE pedidos P
set p.total=(select sum(d.cantidad * d.precio)
from detalle_pedidos d 
where d.id_pedido = p.id_pedido);

select id_pedido, id_cliente, estado, total 
from pedidos;

/*
consultas basicas read de una base de datos
1.columnas especificas con alias para nombrarlas mejor 
*/

select nombre as producto, precio as 
precio_venta, stock as unidades from productos; 

/*
where  con operadores de comparacion logicos  and, or, not
*/

select nombre, precio, stock
from productos
where precio >100000 and stock >=20;

/*between (rango, incluye los extremos)*/

select nombre, precio from productos
where precio between 20000 and 2000000;

--lista de valores con in 
select  nombre_cliente, apellido_cliente, ciudad from clientes 
where ciudad in ("medellin", "bogota");

---like: % = cualquier cantidad de caracteres, exactamente un caracter
select nombre_cliente, apellido_cliente, email
from clientes where apellido_cliente like "R%";

--- is null / is not null no se considera el valor nulo en las comparaciones 
select nombre_cliente, apellido_cliente from clientes
where telefono is null;

---order by  ordena el resultado de una consulta de manera ascendente o descendente 
select nombre, precio from productos
order by precio desc
limit 3;

---distinct: elimina los registros duplicados de una consulta
select distinct ciudad from clientes order by ciudad;

---columnas calculada y funcion de texto 
select concat(nombre_cliente,"", apellido_cliente) as cliente_completo,
upper(ciudad) as ciudad_mayuscula,
char_length(email) as largo_email
from clientes;

--- case: logica condicional dentro de la consulta 
select nombre, stock,
case 
  when stock < 20 then "stock bajo"
  when stock < 100 then "stock medio"
  else "stock alto"
  end as nivel_stock 
  from productos;

/*
JOINS CONSULTAS ENTRE VARIAS TABLAS 
INNER JOIN: devuelve solo las filas que tienen coincidencias en ambas tablas
RIGHT JOIN: devuelve todas las filas de la tabla derecha y las filas coincidentes de la tabla izquierda
LEFT JOIN: devuelve todas las filas de la tabla izquierda y las filas coincidentes de la tabla
FULL JOIN: devuelve todas las filas cuando hay una coincidencia en una de las tablas (emulado con UNION)
Se usan alias cortos para no repetir los nombres de las tablas de consulta
*/

---inner join: productos con el mismo nombre en la categoria 
select p.nombre as producto, c.nombre as categoria, p.precio
from productos P
inner join categorias c on c.id_categoria = p.id_categoria
order by c.nombre, p.nombre;

--- inner join pedidos con el mismo nombre cliente 
select pe.id_pedido, pe.fecha_pedido, pe.estado, pe.total,
concat(cl.nombre_cliente,"",cl.apellido_cliente)
as clientes from pedidos pe
inner join clientes cl on cl.id_cliente = pe.id_cliente
order by pe.fecha_pedido;

---factura detallada de un pedido con inner join entre 4 tablas
select pe.id_pedido,
concat (cl.nombre_cliente,"",cl.apellido_cliente) as cliente,
pr.nombre as producto,
d.cantidad,
d.precio,
d.cantidad * d.precio as subtotal 
from pedidos pe
inner join clientes cl on cl.id_cliente = pe.id_cliente
inner join detalle_pedidos d on d.id_pedido = pe.id_pedido
inner join productos pr on pr.id_producto = d.id_producto
order by pe.id_pedido, pr.nombre;

---left join todos los clientes tengan o no pedidos

select cl.nombre_cliente, cl.apellido_cliente, pe.id_pedido, pe.total
from clientes cl
left join pedidos pe on pe.id_cliente = cl.id_cliente 
order by cl.id_cliente;

---left join + is null productos que nunca se han vendido

select pr.nombre, pr.stock
from productos pr
left join detalle_pedidos d on d.id_producto = pr.id_producto
where d.id_detalle is null;

--- right join todas las categorias  aunque tengan productos 
select c.nombre as categorias, p.nombre as productos
from productos P
right join categorias c on c.id_categoria = p.id_categoria
order by c.nombre;----juguetes aparecer 

--- full outer emulado es decir une (left join y right join)
select c.nombre as categorias, p.nombre as productos
from categorias c left join productos p on p.id_categoria = c.id_categoria
union 
select c.nombre, p.nombre
from categorias c right join productos p on p.id_categoria = c.id_categoria;

/*
funciones de agregacion  count, sum, avg, min, max
resumen muchas filas en un solo valor 
group by agrupa las filas para calcular  el resumen 
por grupo 
having filtra grupos (where  filtar filas antes de agrupar)
regla toda columna del select que no este en una funcion de agragacion debe ir en el group by

*/
---resumen general de los productos 

select count(*) as total,
sum(stock) as unidades_en_bodega,
round(avg(precio),2) as precio_promedio,
min(precio) as precio_minimo,
max(precio) as precio_maximo
from productos;

---cantidad de productos y valor del inventario por categoria
select c.nombre as categoria,
count(p.id_producto) as cantidad_productos,
sum(p.precio * p.stock) as valor_inventario
from categorias c
left join productos p on p.id_categoria = c.id_categoria
group by c.nombre
order by valor_inventario desc; 

---total comprado por cliente (sin pedidos cancelados)
select concat(cl.nombre_cliente, "", cl.apellido_cliente) as clientes,
       count(pe.id_pedido)                             as numero_pedidos,
       sum(pe.total)                                   as total_comprado
       from clientes cl
       inner join pedidos pe on pe.id_cliente = cl.id_cliente
       where pe.estado <> "cancelado" -- where: filtra filas antes de agrupar
       group by cl.id_cliente, cl.nombre_cliente, cl.apellido_cliente
       order by total_comprado desc;      

--- having clientes que han comprado mas de 1.000.000 
select concat(cl.nombre_cliente,"", cl.apellido_cliente) as clientes,
       sum(pe.total)                                     as total_comprado
      from clientes cl
      inner join pedidos pe on pe.id_cliente = cl.id_cliente
      where pe.estado <> "cancelado"
      group by cl.id_cliente, cl.nombre_cliente, cl.apellido_cliente
      having sum(pe.total) > 1000000; 

---ventas por mes 
select date_format(fecha_pedido, "%Y-%m") as mes,
      count(*) as pedidos,
      sum(total) as ventas
      from pedidos 
      where estado <> "cancelado"
      group by date_format(fecha_pedido, "%Y-%m")
      order by mes;

---unidades vendidas por producto
    select pr.nombre, sum(d.cantidad) as unidades_vendidas 
      from detalle_pedidos d
      inner join productos pr on pr.id_producto = d.id_producto
      inner join pedidos pe on pe.id_pedido = d.id_pedido
      where pe.estado <> "cancelado"
      group by pr.id_producto, pr.nombre
      order by unidades_vendidas desc;

---pedidos por estado
select estado, count(*) as cantidad, sum(total) as valor
from pedidos 
group by estado;

/*
subconsultas un a consulta dentro de otra  
*/

--subconsultas en where (valor unico) productos mas caros que el promedio 
select nombre, precio
from productos 
where precio > (select avg(precio) from productos);

--subconsulta con in (lista) clientes que han hecho almenos un pedido
select nombre_cliente, apellido_cliente
from clientes
where id_cliente in (select id_cliente from pedidos);

--not exist: categorias que no tienen productos 
select c.nombre 
from categorias c
where not exists (select 1 from productos p where p.id_categoria = c.id_categoria);

--subconsulta  escalar en select: numero de pedidos de cada cliente
select cl.nombre_cliente, cl.apellido_cliente,
(select count(*) from pedidos pe where pe.id_cliente = cl.id_cliente) as cantidad_pedidos
from clientes cl;

-- subconsulta en from (tabla derivada) promedio de comprar por cliente
select round(avg(t.total_cliente), 2) as promedio_compra_por_cliente
from (select id_cliente, sum(total) as total_cliente
from pedidos
where estado <> "cancelado"
group by id_cliente) as t;
-- en mysql una tabla derivada necesita un alias em este caso "T" y NO 
--se puede usar el alias en la misma consulta por eso se hace subconsulta from

--subconsulta correlacionada productos mas caros que el promedio de su categroia
select p.nombre, p.precio, p.id_categoria
from productos P
where p.precio > (select avg (p2.precio)
from productos p2
where p2.id_categoria = p.id_categoria);

--subconsulta  el pedido de mayor valor con max
select id_pedido, id_cliente, total
from pedidos 
where total = (select max(total) from pedidos);

/*
crud completo  + transacciones 
una transaccion agrupa varias setencias en una sola unidad o se guardan todas 
en un commit o no se guarda ninguna rollback
propiedades: acid:atomicidad consistencia, aislamiento, durabilidad 
*/
--c= create registrar un cliente nuevo 
insert into clientes (tipo_documento, numero_documento, nombre_cliente, apellido_cliente, email, telefono, ciudad)
values ("cc","100900909", "sofia","cardona mejia","sofia.cardona@correo.com","3109990000","manizales");

--r_read consultarlo
select * from clientes where numero_documento = "100900909";

--u= update
update clientes
set telefono = "3101234567",
ciudad = "armenia"
where numero_documento = "1009009009";

--delete eliminar siempre con where porque sin where elimina toda la tabla 
delete from clientes where numero_documento = "100900909";

--transacciones con  rollback simulamos una venta y nos arrepentimos de la venta y no se guarda nada en la base de datos 
start transaction;
insert into pedidos (id_cliente, estado) values (8,"pendiente");
set @nuevo_pedido_id = last_insert_id(); -- id generado por el ultimo insert

insert into detalle_pedidos (id_pedido, id_producto, cantidad, precio)
values (@nuevo_pedido_id, 12, 1, 120000);

update productos set stock = stock -1 where
id_producto = 12;

select * from pedidos where id_pedido = @nuevo_pedido;

---dentro de la transaccion se puede consultar lon que se ha hecho pero no se ve desde afuera

rollback; --- deshacer la transaccion y no se guarda nada en la base de datos 

select * from pedidos where id_pedido = @nuevo_pedido;
--YA no existe
select stock from productos where id_producto = 12;
-- el stock deberia seguir en 5

--transaccion con commit: subir 5% el precio a deportes 
start transaction;
update productos
set precio = round(precio * 1.05,0)
where id_categoria = (select id_categoria
from categorias where nombre = "deportes" );
commit;

--confirma el cambio de forma permanente
select nombre, precio from productos where id_categoria = 4;

--delete en cascada: al borrar un pedido se borran sus detalles
insert into pedidos (id_cliente, estado )
values (8, "pendiente");
set @pedido_tem = last_insert_id();
insert into detalle_pedidos (id_pedido, id_producto, cantidad, precio)
values (@pedido_tem, 2, 1, 45000);

select count(*) as detalles_antes from detalle_pedidos
where id_pedido = @pedido_tem; --1
delete from pedidos where id_pedido = @pedido_tem;
select count(*) as detalles_despues from detalle_pedidos
where id_pedido = @pedido_tem; --0