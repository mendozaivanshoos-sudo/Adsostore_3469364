// configurar y exportar un pool de conexiones hacia mysql
//un pool es un frupo de conexiones que se utilizan en cada
// consulta den lugar de abrir y cerrar una conexion una cada vez
//eso hace que la aplicacion responda mas rapido 
//mysql/promise nos permite usar async await en las consultas
//en lugar de trabajar callbacks

const mysqly = require('mysql2/promise');
//cargamos las variables definidas en el archivo .env
//(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME)
require('dotenv').config();

//createPool crea un conjunto de conexiones reutilizables
const pool = mysqly.createPoolCluster({
    host: process.env.DB_HOST,//servidor de mysql
    port: process.env.DB_PORT,//puerto de mysql
    user: process.env.DB_USER,// usuario de mysql
    password: process.env.DB_PASSWORD,// contraseña de mysql
    database: process.env.DB_NAME,//nombre de la base de datos
    wairForConnections: true,//si no hay conexiones libres
    connectionLimit:10, //max de conexiones simultaneas
    queuelimit:0,// sin limites de conexiones en espera
});

//exportamos el pool para poder hacer pool.query desde cualquier controlador

module.exports = pool;