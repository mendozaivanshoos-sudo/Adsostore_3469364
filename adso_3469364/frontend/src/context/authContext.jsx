/**
 * contexto global de autenticacion permite cualquier 
 * componente de la app (sidebar, navbar,paginas proegidas y demas)
 * sepa si hay un usuario logueado quien es y pueda cerrar sesion 
 * sin tener que pasar esa informacion "a mano" del componente en
 * componente (eso se llama "prop drilling y el context lo evita")
 */
// createcontext:crea el contexto; usecontext: lo consume; useEffect:
// Codigo corre en momentos especificos del ciclo de la vida; useState:
//El estado local del componente
import{
     createContext, useContext, useEffect, useState} from 'react';
     //funcion que llama al backend para validar email/password
     import { iniciarSesion } from '../api/authService';

     //1) creamos el contexto (una especie de caja compartida)
     const AuthContext = createContext(null);
     //2) componente proveedor: envuelve la app y la de sus 
     //hijos acceso al valor de autenticacion actual
     export function AuthProvider ({children}){
        //USUARIO: Datos publicos del usuario logueado (o null si no hay sesion)
        const [usuario, setusuario] = useState (null);

        //cargando: true mientras revisamos si habia una sesion guardada
        //en el localstorage (por ejemplo al recargar con f5 )
        const [cargando, setCargando] =  useState (true);
        //use effect con arreglo vacio []-> se ejecuta una sola vez,
        //justo cuando la app arranca 
        useEffect(()=>{
            const usuarioGuardado = localStorage.getItem('usuario');
            const tokenGuardado = localStorage.getItem('token');

            
        // si el localstorage ya hay un usuario token de una sesion anterior
        //restauramos esa sesion sin obligar a volver hacer login 
        if (usuarioGuardado && tokenGuardado){
            setusuario(JSON.parse(usuarioGuardado));
        }
        });

     }
     /**
 * Pantalla login funcional
 * pantalla publica de inicio de sesion es la unica parte del
 * sistema que habla con la base de datos MYSQL real a travez del
 * backend Node/Express si las credenciales son correctas
 * redirije al usuario al dashboard
 */

// Hook del estado local para los campos del formulario
import { useState } from "react";
// Hook para redirijir por codigo despues de iniciar sesion
import { useNavigate } from "react-router-dom";
// Hook para llamar a login() del contexto global de sesion
 import { useAuth } from "../context2/AuthContext";

// no recibira props es el element de la ruta / login en App.jsx
function LoginPage() {
    // Traemos sola la funcion login() del contexto no se necesita mas
    const { login } = useAuth();
    // Funcion para cambiar la url una vez el login sea exitoso
    const nagative = useNavigate();

    // estado del formulario controlado
    const [email, setEmail] = useState("");
    const [password, setPassword] = useState("");

    // Estado para mostrar el error que devuelve el backend credenciales
    // invalidas, usuario desactivado servidor caida o demas
    const [error, setError] = useState("");

    // estado para desahibilitar el boton mientras espera la respuesta
    // del servidor y evitar que el usuario haga doble click
    const [enviado, setEnviado] = useState(false);

    // se ejecuta cuando el usuario envia el formulario boton o enter
    async function manejarEnvio(evento) {
        evento.preventDefault(); // evita que el navegador recargue la pagina
        setError(""); // limpia cualquier error de un intento anterior
        setEnviado(true); // deshabilitar el boton mientras esperamos la respuesta

        try{
            // login() esta definido en AuthContext: llama al backend
            // Guarda el token/usuario y actualiza el estado global
            await login (email, password);

            // si no lanzo error, las credenciales fueron correctas
            Navigate("/dashboard", {replace:true});
        }catch (err) {
            // si el backend respondio un mensaje error (401, 403 ...)
            // axios los deja disponible en err.response.data.mensaje
            const mensajeBackend = err?.response?.data?.mensaje;
            setError(mensajeBackend || "no se pudo conectar con el servior. Verifica que el backend este corriendo");
        }finally {
            // finally se ejecuta siempre (haya exito o error reactivamos el boton)
            setEnviado(false);
        }
        
    }
}