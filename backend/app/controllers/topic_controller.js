const express = require("express");
const Topic = require("../models/topic");
const { jwtMiddleware } = require("../../config/middlewares");
const router = express.Router();

// GET: BASE_URL + /apis/v1/users
router.get("/", jwtMiddleware, async (req, res) => {
  const topics = await Topic.findAll();
  res.json(topics);
});

router.get("/:id", jwtMiddleware, async (req, res) => {
  // recibir parametros
  const { id } = req.params;
  // trabajar respuesta
  var response = {};
  var status = null;
  try {
    const topic = await Topic.findOne({
      where: {
        id: id,
      },
    });
    if (topic) {
      status = 200;
      response = topic;
    } else {
      status = 404;
      response = {
        message: "Tema no encontrado",
        detail: "No se encontró un tema con el ID proporcionado",
      };
    }
  } catch (error) {
    console.error("Error al buscar el tema:", error);
    status = 404;
    response = {
      message: "Tema no encontrado",
      detail: error,
    };
  }
  // enviar respuesta
  res.status(status).json(response);
});

module.exports = router;
