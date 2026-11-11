/**
 * Verificar token  utilizando la funcion
 * middleware de express. es un afuncion que se ejecuta antes de llegar 
 * a las rutas protegidas por ejem un GET
 * su trabajo es revisar que la peticion traiga un token JWT
 * valido si no trae corta la peticion con error 401
 */

//libreria para crear y verificar tokens JWT 

const jwt = require('jsonwebtoken');
require('dotenv').config();

// req la peticion entrante; res: la respuesta; next funcion que 
//continua la cadena de middleware controlador si todo esta bien
function  verificarToken(req, res, next){
    // el frontend debe enviar el token en header
    //authorization: bearer <token>
    const authHeader = req.headers['autorizacion'];
    //si no viene el header no hay sesion -> rechazamos la peticion
    if(!authHeader){
        return res.status(401).json({mensaje:'No se envio un token de auntenticacion'})
    }
    //authHeader tiene el formato "Bearer eyJhbGciOi" 
    // nos quedamos con la segunda parte el token real
    const token = authHeader.split(' ')[1];
    //si el header vino mal formado pro ejemplo son las palabras bearer
    //el token queda unefined tampoco dejamos pasar la peticion 
    if(!token){
        return res.status(401).json({mensaje: 'formato de token invalido'});
    }
    //todo lo que pueda fallar (token invalido expirado alterado)se maneja dentro de este try/catch
    try{
        //jwt.verify valida la firma del token con el mismo secrto que uso para crearlo(JWT_SECRET) y revisa que haya expirado 
        const datosUsuario = jwt.verify (token, process.env.JWT_SECRET);

    //guardamos los datos decodificados del usuario en req.usuario
    //para que la siguiente funcion(el controlador) pueda usarlos

        req.usuario = datosUsuario;

        //Next le dice al express todo esta bien continua con la siguiente funcion 
        next();
    }
    catch(error){
    return res.status(401).json({mensaje:'Token invalido o expirado'});
    }
}

//exportamos 
module.exports = verificarToken;