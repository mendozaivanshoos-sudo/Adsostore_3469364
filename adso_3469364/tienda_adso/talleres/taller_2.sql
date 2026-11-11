--punto 1
insert into proveedores (nit, razon_social, telefono, email, ciudad) 
values 
("111222333","lenovo","3201212131","sam.sung@correo.com", "bogota"),
("111223334","oster", "3101212132","os.ter@correo.com", "medellin"),
("111233345","marcadores","3151222332", "mar.cadore@correo.com","pereira");

update productos
set id_proveedor = 1
where id_categoria = 1;

update productos
set id_proveedor = 2
where id_categoria = 2;

update productos
set id_proveedor = 3
where id_categoria = 3;

---punto 2
 
SELECT p.nombre AS producto,
c.nombre AS categoria,
pr.razon_social AS proveedor
FROM productos p
LEFT JOIN categorias c ON p.id_categoria = c.id_categoria
LEFT JOIN proveedores pr ON p.id_proveedor = pr.id_proveedor
ORDER BY p.id_categoria ASC;

--punto 3
select cl.ciudad,
count(pe.id_pedido) as numero_pedidos,
sum(pe.total) as total_vendido,
pe.estado as estado
from clientes cl
inner join pedidos pe on pe.id_cliente = cl.id_cliente
where pe.estado <> "cancelado"
group by  cl.ciudad
order by total_vendido desc;   

--punto 4   
select pr.nombre, sum(d.cantidad) as unidades_vendidas 
from detalle_pedidos d
inner join productos pr on pr.id_producto = d.id_producto
inner join pedidos pe on pe.id_pedido = d.id_pedido
where pe.estado <> "cancelado"
group by pr.id_producto, pr.nombre
order by unidades_vendidas desc
limit 1;

--punto 5
   select concat(cl.nombre_cliente, ' ', cl.apellido_cliente) as clientes,
sum(pe.total) as total_comprado
from clientes cl
inner join pedidos pe on pe.id_cliente = cl.id_cliente
where pe.estado <> 'cancelado'
group by cl.id_cliente, cl.nombre_cliente, cl.apellido_cliente
having sum(pe.total) > (select avg(t.total_cliente)
from (
select sum(total) as total_cliente
from pedidos
where estado <> 'cancelado'
 group by id_cliente) as t);

--punto 6
select c.*
from categorias c
where not exists ( SELECT 1
FROM productos pr
INNER JOIN detalle_pedidos dp ON dp.id_producto = pr.id_producto
WHERE pr.id_categoria = c.id_categoria);
rollback;
SELECT nombre, precio from productos where id_categoria = 3;

--punto 7
start transaction;
update productos
set precio = round(precio * 1.10,0)
where id_categoria = (select id_categoria
from categorias where nombre = "papeleria" );

select nombre, precio from productos where id_categoria = 3;

rollback;

--punto 8 
delete from pedidos where estado = 'cancelado';

SELECT d.* 
FROM detalle_pedidos d
JOIN pedidos p ON d.id_pedido = p.id_pedido
WHERE p.estado = 'cancelado';