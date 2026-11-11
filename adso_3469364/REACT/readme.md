# PROYECTO EN REACT SISTEMA DE INVENTARIO
Elaborado con reac + bootstrap y mysql

el sistema de inventario contara con inicio de sesion con base de datos en mysql con contraseña 
encriptada y jwt (jason web token) 
El dahsboard CONTARA CON GESTION CRUD  de **usuarios, categorias, subcategorias, productos**
usando datos simulados en JavaScript 

# stack usado
el frontend = react 19 + vite bootsrap 5 + react router 
back (solo para login) = node.js + express + jwt
base de datos = mysql (xampp) + inventario_react 
encriptacion de contraseña = bcrypt (bcryptjs)
gestiones = usuarios, categorias, productos/ datos simulados en js (usesatage + localstorage)
automatizacion npm scripts + concurrently

PRE - REQUISITOS 
# 1 
instalar node.js verificar desde cmd con node -v

# 2
tener xampp  instalado con mysql en puerto 3306

# 3
tener un editor de codigo 

CONOCIMIENTOS PREVIOS

** COMPONENTE **
La pantalla se divide en piezas pequeñas y reutilzables 
(un boton, tabla, formulario, un menu) cada componente es una funcion de java script
que devuelve lo que tiene que mostrar 
**JSX** una sintxis que permite escribir algo parecido a html dentro de java script por eso 
los archivos terminan con extension .jsx ejemplo:

```JSX
function saludo  (){
    return <h1 classname=" text-primary">hola,react</h1>
}
```
- **Estado (stage)** cada componente puede guardar  datos que cambian por ejemplo , lo que el usuario escribe em un input cuando el estado cambia react vuelve a dibujar automaticamente solo lo necesario sin recargar la pagina

**SPA** La aplicacion se encarga una sola vez en el navegador y luego cambia de pagina sin recargar para esto usamos ´react-router-dom´

react solo se encarga de la interfaz grafica para el resto utilizamos: 
**VITE** para crear y correr el proyecto 
**bootstrap** para los estilos 
**axios** para hablar entre frontend y el backend
**react-router-dom* para las rutas 

# PASOS PARA CREAR EL PROYECTO

-1 Verificar que tenga node.js (node -v) cmd
-2 desde la raiz del proyecto crea el proyecto react y vite 
cd
-3 Entre a la carpeta frontend  con `cd fontend` e instale npm `npminstall`
-4 instale las librerias: `npm install bootstrap, bootstrap-icons, react-router-dom axios`
-5 empaquetador optimisa y junta todo el css en un solo archivo al hacer `npm run build`
-6 Instalar las dependependencias del backend y el frontend al tiempo `npm run install:all`
-7 ingresar a la carpeta backend `npm init -y`
-8 instalar dependencias 
--8.1 `npm install express msql2 bcryptjs jsonwebtoken cors dotenv`
--8.2 crea .env dentro de backend 
--8.3 crea src/config/db.js
--8.4 crea src/middlewares/verificarToken.js valida el token jwt en rutas protegidas
--8.5 crea src/controllers/auth.controller.js es la logica de inicio de sesion  
--8.6 Crea src/routes/auth.routes.js (conecta las rutas con el controlador) 
--8.7 crea src/server.js (arma la app de express)
--8.8 crea en backend seed.js (crea el usuario del administrador)
-9 crear las siguientes carpetas en frontend
--9.1 src/api/axioClient.js
--9.2 src/api/authService.js
--9.3 src/context/authContext.jsx
--9.4 src/page/loadPage.jsx