// scripts/update_passwords.js
const bcrypt = require('bcryptjs');
const database = require('../src/config/database');

async function updatePasswords() {
  try {
    console.log('🔐 Actualizando passwords de usuarios de prueba...');
    
    await database.connect();
    const db = database.getDb();
    
    // Passwords de prueba (plaintext)
    const testUsers = [
      { id: 1, email: 'usuario1@example.com', password: 'password123' },
      { id: 2, email: 'usuario2@example.com', password: 'password123' },
      { id: 3, email: 'user3@test.com', password: 'password123' },
      { id: 4, email: 'user4@test.com', password: 'password123' },
      { id: 5, email: 'user5@test.com', password: 'password123' }
    ];
    
    console.log('📝 Hasheando passwords...');
    
    for (const user of testUsers) {
      const hashedPassword = await bcrypt.hash(user.password, 10);
      
      db.run(
        'UPDATE usuarios SET password_hash = ? WHERE usuario_id = ?',
        [hashedPassword, user.id],
        function(err) {
          if (err) {
            console.error(`❌ Error actualizando usuario ${user.email}:`, err.message);
          } else {
            console.log(`✅ Password actualizado para ${user.email}`);
          }
        }
      );
    }
    
    console.log('\n🎯 Credenciales de prueba:');
    console.log('Email: usuario1@example.com | Password: password123');
    console.log('Email: user3@test.com | Password: password123');
    console.log('Email: user4@test.com | Password: password123');
    
    setTimeout(() => {
      database.close();
      console.log('\n✅ Passwords actualizados correctamente');
    }, 1000);
    
  } catch (error) {
    console.error('❌ Error:', error);
  }
}

updatePasswords();
