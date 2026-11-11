/*
*aqui vive la logica del negocio del login recibe email 
y contraseña, buscar el usuario en 
mysql comparar la contraseña buscar
el usuario en mysql  comparar la contraseña
*las rutas (auth.routes.js) solo dicen cuando llega la data 
*peticion llama a esta funcion logica esn si va aca (CRUD)
*/

//LIBRERIA PARA ENCRIPTAR  y comparar la contraseña
const bcrypt =require('bcrypt');
//librebria para crear (frimar) tokens jwt de sesion
const jwt =require('jsonwebtoken');
//pool para conexiones mysql configurado en config/db.js
const pool =require('../config/bd');
//carga las variables de .env(JWT_SECRET, JWT_EXPIRES_IN)
require('dotenv').config();

//POST /API/AUTH/LOGIN
//RECIBE {EMAIL, PASSWORD} Y DEVUELVE {TOKEN, USUARIO} SI SON CORRECTOS
async function login(req, res) {
    try{
    //extraemos el email y password de cuerpo (body) de la peticion 
    //express.json() ya convirtio de json a objeto de JavaScript
    const {email, password}= req.body;


    //1 validacion basica que no llegue al formulario vacio 
    if(!email||!password){
        return res.status(400).json
        ({mensaje:'el correo y la contraseña son obligatorios'});
    }

    //2buscamos el usuario por email en la tabla usuarios 
    //usamos "?" en la consulta (no contatenamos el email directo )
    //para evitar la inyeccion sql: mysql2 se encarga de escaparlo
    const [filas] = await pool.query(
        'select id, nombre, email, password, rol, estado from usuarios where email = ? limit 1, ', [email]
    );
    // si no encontro ninguna fila, el correo no existe
    if (filas.length ===0){
        return res.status(401).json({
            mensaje:'correo o contraseña incorrectos'
        });
    }
    //pool.query con select siempre devuelve un arreglo de fila; como 
    // buscamos por email (lo unico), nos quedamos con la primera fila y unica
    const usuario = filas[0];
    //si el usuario fue desactivado no dejamos iniciar sesion
    //aunque la contraseña sea correcta 
    if (usuario.estado ===0){
        return res.status(403).json({
            message: 'este usuario esta desactivado contacte al administrador'
        });
    }

    /*
     * comparar la contraseña que envio el formulario con el hash
     * guardado en la base de datos bcrypt. compare vuelve aplicar
     * el mismo algoritmo y revisa si el resultado coincide la 
     * contraseña original 
     */
    const passwordcorrecta = await bcrypt.compare (password, usuario.password);
    if (!passwordcorrecta){
        return res.status(401).json({
            message:'correo o contraseña incorrectos'
        })
        }
        /*
         * genera un token jwt que el frontend guarda para
         * demostrar en cada peticion futura que ya inicio sesion
         */
        const token = jwt.sign(
            {id: usuario.id, email: usuario.email, rol: usuario.rol},//datos dentro del token
            process.env.JWT_SECRET, //firma secreta
            {expiresIn: process.env.JWT_EXPIRES_IN || '8h'} //tiempo de vida del token
        );
        /**
         * responder token con los datos publicos del usuario 
         * nunca se devuelve al frontend 
         */
        return res.json({
            token,
            usuario:{
                nombre: usuario.nombre,
                email: usuario.email,
                rol: usuario.rol,
            },
        });
} catch (error) {
    //cualquier error inesperado (por ejemplo en mysql este pagado)
    //cae aqui en vez de tumbar el servidor 
    console.error('error login:', error);
    return res.status(500).json({mensaje:'error del servidor al iniciar sesion'});

    

}
}

//get/api/auth/perfil 
//ruta protegida de ejemplo solo responde a personas si el middleware
//verificacion de token confirmo que el token es valido
async function perfil(req, res) {
    return res.json({usuario:req.usuario});

    
}
//exportamos ambas funciones para authroutes.js pueda contactarlas 
//con las urls correspondientes
module.exports = {login, perfil};