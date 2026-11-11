/**
 * se crea una instancia configurada de axios para hablar con el
 * backend  (node/express) en vez de escribir la url completa 
 * cada peticion de la dejamos configurada una sola vez aqui
 */

//libreria para hacer peticiones HTTP (GET POST)
import axios from 'axios';

/*
* url base del backend en un proyecto real esto vendria  de una
*variable de entorno de vite (import.meta.env VITE_API_URL),
* pero vamos a dejar fija apuntando al backend
*/

const API_URL = 'http//localhost:4000/api';
//axios.create genera una instancia propia distinta del axios global 
//con configiracion ya lista para usar en toda la aplicacion
const axiosClient = axios.create({
    baseURL:API_URL, //se antepone automaticamente a cada ruta relativa ej: /auth/login 
    headers:{
        'Content-Type': 'application/json', //le avisamos al backend que mandamos el json 
    },

});
/*
*interceptor de peticiones se ejecuta antes de enviar cada 
*peticion aqui aprovecharemos para agregar automaticamente el
*token JWT guardado en el localstorage (si existe ) el header
authorization para no tener que repetirlo en cada llamada 
 */
axiosClient.interceptors.request.use((config)=>{
    //revisamos si hay un token guardado de una sesion iniciada

const token = localStorage.getItem('token');
if (token){
    //lo agregamos al header en el formato que espera el backend:
    //Authorization: Beader <token>
    config.headers.Authorization = `Bearer ${token}`;

}
//siempre hay que devolver "config" si o no la peticion nunca se envia 
return config;
});
//exportamos la instancia ya configurada para usarla en toda la app
export default axiosClient;