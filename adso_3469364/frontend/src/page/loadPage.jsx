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
    return (
    <div className="login-wraper">
        <div className="card shadow-lg border-0" style={{ width: "100%", maxWidth: 400 }}>
            <div className="card-body p-4 p-md-5">

                <div className="text-center mb-4">
                    <i className="bi bi-boxes text-primary" style={{ fontSize: "2.5rem" }}></i>
                    <h1 className="h4 mt-2 mb-0">Inventario React</h1>
                    <p className="text-muted small">Ingresar con tu cuenta registrada</p>
                </div>

                {/* Solo muestra si error tiene contenido */}
                {error && <div className="alert alert-danger py-2">{error}</div>}

                <form onSubmit={manejarEnvio}>
                    <div className="mb-3">
                        <label className="form-label">Correo electrónico</label>
                        <input
                            type="email"
                            className="form-control"
                            placeholder="admin@inventario.com"
                            value={email}
                            onChange={(e) => setEmail(e.target.value)}
                            required
                            autoFocus
                        />
                    </div>

                    <button type="submit" className="btn btn-primary w-100" disabled={enviado}>
                        {enviado ? "Enviando..." : "Ingresar"}
                    </button>
                </form>

            </div>
        </div>
    </div>
);
}
// exportamos la pagina para usarla en la ruta /login de app.jsx
export default LoginPage;