function jwtMiddleware(req, res, next) {
  console.log('XDDDDDDDDDDDDDDDD');
  next();  // MUY IMPORTANTE: llama a next() para continuar a la ruta
}

module.exports = {
  jwtMiddleware,
};