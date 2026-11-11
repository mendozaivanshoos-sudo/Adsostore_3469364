/*
*concentra las llamadas a la API relacionadas con autenticaion 
*los componentes (por ejemplo loginpage) no lo llaman axios
* directamente llaman a estas funciones que son mas faciles 
*de leer y reutilizar
*/
//instancia de axios ya configurada con la url dle backend y el token 
import axiosClient from "./axioClient";
import axios from "./axioClient";

//envia email y password al backend 
//responde con {token, usuario} si no axios lanza un error
//que el componente que llama debe capturar con try/catch
export async function iniciarSesion(email, password) {
    const respuesta = await axiosClient.post ('/auth/login',{ email, password});
    return respuesta.data; // el token, usuario
    
}

//pide al backend los datos del usuario dueño del token actual
//sirve por ejemplo para validar sesion cuando carga la pagina
export async function obtenerperfil() {
    const respuesta = await axiosClient.get
    ('/auth/perfil');
    return respuesta.data;
    
}