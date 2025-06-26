const express = require("express");
const User = require("../models/user");
const { jwtMiddleware } = require("../../config/middlewares");
const router = express.Router();

// GET: BASE_URL + /apis/v1/topics
router.get("/", jwtMiddleware, async (req, res) => {
  const users = await User.findAll();
  res.json(users);
});

router.post("/sign-in", async (req, res) => {
  // recibir parametros
  const { username, password } = req.body;
  // trabajar respuesta
  var response = {};
  var status = null;
  try {
    if (!username || !password) {
      response = {
        message: "No envió usuario y contraseña",
        detail: "",
      };
      status = 500;
    } else {
      const user = await User.findOne({
        where: {
          username: username,
          password: password,
        },
      });
      if (user) {
        status = 200;
        response = user;
      } else {
        status = 404;
        response = {
          message: "Usuario no encontrado",
          detail: "",
        };
      }
    }
  } catch (error) {
    console.error("Error al buscar el tema:", error);
    status = 500;
    response = {
      message: "Tema no encontrado",
      detail: error,
    };
  }
  // enviar respuesta
  res.status(status).json(response);
});

module.exports = router;
