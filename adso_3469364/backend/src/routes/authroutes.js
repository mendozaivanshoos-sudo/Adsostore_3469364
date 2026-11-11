/*
*define las urls (endpoints) relacionales con autenticacion
*las conecta con su funcion controladora correspondiente
 */
//framework del servidor 
const express = require('express');
//router in mini servdior de rutas que despues se montan en el server.js
// con una app.use (api/auth), authroutes
const router = express.Router();

//funciones controladas con la logica real de cada endpoint
const { login, perfil } = require('../controllers/authcontroller');
//middleware que protege rutas exigiendo un token jwt valido
const verificartoken = require('../middlewares/verificartoken');
 
//post/api/auth/login = iniciar sesion (ruta publica) 

router.post('/login', login );

//GET api/auth/perfil = delviuelve los datos de usuario logueado 
//ruta protegida pasa primero por la verificarToken 
router.get('/perfil', verificartoken, perfil);

//exportamos el router para que pueda ser montado en el server.js
module.exports = router;