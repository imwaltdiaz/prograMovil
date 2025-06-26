const express = require("express");
const http = require("http");
const { Server } = require("socket.io");
const morgan = require("morgan");
const homeController = require("./app/controllers/home_controller");
const topicController = require("./app/controllers/topic_controller");
const userController = require("./app/controllers/user_controller");
const chatSocket = require("./app/sockets/chat_socket");

const app = express();
const server = http.createServer(app);
const io = new Server(server);

// Configuración de la app
app.set("view engine", "ejs");
app.set("views", "./views");

// Middlewares y rutas
app.use(morgan("dev"));
app.use(express.static("public"));
app.use("/", homeController);
app.use("/apis/v1/topics", topicController);
app.use("/apis/v1/users", userController);

// Sockets
chatSocket(io);

// ✅ Usar el puerto dinámico de Replit o 3000 por defecto
const PORT = process.env.PORT || 3000;
server.listen(PORT, () => {
  console.log(`Servidor corriendo en http://localhost:${PORT}`);
});
