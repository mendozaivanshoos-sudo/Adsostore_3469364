//esta ayuda a detectar errores comunes en el desarrollo
import { StrictMode } from 'react'
//es la funcion moderna de react 18+ para montra la palicaicon en el dom
import { createRoot } from 'react-dom/client'

//habilita el amnajeo de las rutas 
import {BrowserRouter, browserrouter} from 'react-router-dom'
//estilos boostrap clases btn container tablas y demas
import'bootstrap/dist/css/bootstrap.min.css';
//iconos de booststrap clases como bi bi-trash
import 'bootstrap-icons/font/bootstrap-icons.css';
//dropdowns y el menu de navegacion
import 'bootstrap/dist/js/bootstrap.bundle.min.js';
//estilos  propios del proyecto se cargan solos despues del booststrap
//describe detalles puntuales a la aplicacion
import './index.css'
//componente raiz con todas las rutas de la aplicacion 
import App from "./App.jsx";
//proveedor cel contexto de sesion (ver context/authcontext.jsx)
import {AuthProvider} from './context/authcontext.jsx'
//busca el <div id="root"> de index.html y engancha react ahi dentro


createRoot(document.getElementById('root')).render(
  <StrictMode>
    {/*BrowserRouter habilida la navegacion por url
    (react-router-dom)*/}
    <BrowserRouter>
      {/*AuthProvider comparte con toda la aplicacion 
      quien es usuario logeado
      */}
      <AuthProvider>
        <app/>
      </AuthProvider>
    </BrowserRouter>
    <App />
  </StrictMode>,
)
