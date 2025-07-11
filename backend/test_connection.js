// Prueba simple de conexión al backend
// Este archivo se puede ejecutar independientemente para verificar la conexión

const http = require('http');

function testBackendConnection() {
  console.log('🔍 Probando conexión al backend...');
  
  const postData = JSON.stringify({
    email: 'usuario1@example.com',
    password: 'password123'
  });

  const options = {
    hostname: 'localhost',
    port: 3001,
    path: '/api/auth/login',
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Content-Length': Buffer.byteLength(postData)
    }
  };

  const req = http.request(options, (res) => {
    console.log(`✅ Status Code: ${res.statusCode}`);
    console.log(`📋 Headers:`, res.headers);
    
    let data = '';
    res.on('data', (chunk) => {
      data += chunk;
    });
    
    res.on('end', () => {
      console.log('📦 Response Body:');
      try {
        const jsonData = JSON.parse(data);
        console.log(JSON.stringify(jsonData, null, 2));
      } catch (e) {
        console.log(data);
      }
    });
  });

  req.on('error', (e) => {
    console.error(`❌ Error de conexión: ${e.message}`);
    console.log('💡 Asegúrate de que el backend esté ejecutándose en puerto 3001');
  });

  req.write(postData);
  req.end();
}

// Verificar si el puerto 3001 está disponible primero
const testConnection = http.request({
  hostname: 'localhost',
  port: 3001,
  path: '/',
  method: 'GET',
  timeout: 2000
}, (res) => {
  console.log('🟢 Backend está ejecutándose, probando login...');
  testBackendConnection();
});

testConnection.on('error', (e) => {
  console.log('🔴 Backend no está ejecutándose');
  console.log('💡 Ejecuta primero: node index.js en el directorio backend');
});

testConnection.on('timeout', () => {
  console.log('⏰ Timeout - Backend no responde');
  testConnection.destroy();
});

testConnection.end();
