const bcrypt = require('bcryptjs');
const database = require('../src/config/database');

// Mapeo de usuarios existentes con sus contraseñas en texto plano
const usersWithPlainPasswords = [
  { id: 1, email: 'usuario1@example.com', password: '123456' },
  { id: 2, email: 'usuario2@example.com', password: '123456' },
  { id: 3, email: 'user3@test.com', password: '123456' },
  { id: 4, email: 'user4@test.com', password: '123456' },
  { id: 5, email: 'user5@test.com', password: '123456' }
];

async function hashPassword(password) {
  const saltRounds = 10;
  return await bcrypt.hash(password, saltRounds);
}

async function updateUserPassword(userId, hashedPassword) {
  return new Promise((resolve, reject) => {
    const query = 'UPDATE usuarios SET password_hash = ? WHERE usuario_id = ?';
    
    database.getDb().run(query, [hashedPassword, userId], function(err) {
      if (err) {
        reject(err);
      } else {
        resolve(this.changes > 0);
      }
    });
  });
}

async function hashAllPasswords() {
  try {
    console.log('🔐 Iniciando proceso de hasheo de contraseñas...\n');
    
    // Conectar a la base de datos
    await database.connect();
    console.log('📊 Conectado a la base de datos\n');
    
    for (const user of usersWithPlainPasswords) {
      console.log(`Procesando usuario: ${user.email} (ID: ${user.id})`);
      
      // Hashear la contraseña
      const hashedPassword = await hashPassword(user.password);
      console.log(`   ✓ Contraseña hasheada: ${hashedPassword.substring(0, 20)}...`);
      
      // Actualizar en la base de datos
      const updated = await updateUserPassword(user.id, hashedPassword);
      
      if (updated) {
        console.log(`   ✓ Actualizado en base de datos\n`);
      } else {
        console.log(`   ✗ Error: Usuario no encontrado en base de datos\n`);
      }
    }
    
    console.log('🎉 Proceso completado exitosamente!');
    console.log('\n📝 Ahora puedes usar las siguientes credenciales para hacer login:');
    console.log('══════════════════════════════════════════════════════════════');
    
    usersWithPlainPasswords.forEach(user => {
      console.log(`Email: ${user.email}`);
      console.log(`Password: ${user.password}`);
      console.log('──────────────────────────────────────────────────────────────');
    });
    
  } catch (error) {
    console.error('❌ Error durante el proceso:', error);
  } finally {
    // Cerrar la conexión a la base de datos
    try {
      await database.close();
    } catch (closeError) {
      console.error('Error cerrando la base de datos:', closeError);
    }
    
    process.exit(0);
  }
}

// Ejecutar el script
console.log('🚀 Script para hashear contraseñas de usuarios existentes');
console.log('═══════════════════════════════════════════════════════════\n');

hashAllPasswords().catch(console.error);
