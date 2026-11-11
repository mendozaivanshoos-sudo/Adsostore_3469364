/**
 * punto de entrada del backend aqui se crea la aplicacion de express se configuran los middleware globales (cord,json)
 * y se montan las rutas al final el servidor qu esta escuchando
 * peticiones por el puerto definido el env (por defecto 4000)
 */
 
//framework para crear en servidor https y definir rutas
const express = require("express");
//middleware que habiita CORS (peticiones desde otro  origen/o puerto)
const cors = require("cors");
//lee el archivo .env y carga susvalores en process.env
require("dotenv").config();
//importemos el router con los endpoints de la api
const authrouter = require("./routes/auth.routes");
//creemos la applicacion express
const app = express();
// cors() permite que el frontend (que corre en otro puerto)
//pueda hacer peticiones a es backend sin que el navegador lo bloquee app.use(cors())
app.use(cors());

//express.json() le enseña a express a leer el body de las peticiones
//cuando viene en formato json asi podemos leer req.boby.email, etc
app.use(express.json());

//ruta de salud simpe util para probar que el servidor esta vivo
app.get("/api/health", (req, res) => {
  res.json({ message: "API is running" });
});

//todas las rutas que empiezen con api/auth se resuelven en authroutes.js
app.use("/api/auth", authrouter);

//middleware  para rutas que no existen (404)
app.use((req, res) => {
  res.status(404).json({ message: "Ruta no encontrada" });
});
// tomamos el puerto desde el .env o usamos 4000 por defecto
const PORT = process.env.PORT || 4000;


//arranca el servidor apartir de aqui express qeuda escuchando
//peticiones HTTP en el puerto definido
app.listen(PORT, () => 
    //este callcack se ejecuta  una vez el servidor esta corriendo y escuchando peticiones    
    {
  console.log(`Servidor corriendo en http://localhost:${PORT}`);
});
