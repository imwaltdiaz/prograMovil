INSERT INTO modelos_ia (modelo_ia_id, proveedor, nombre, identificador_interno_modelo, activo) VALUES
(1, 'OpenAI', 'GPT-4', 'gpt-4', 1),
(2, 'Anthropic', 'Claude 3', 'claude-3', 1),
(3, 'Google', 'Gemini Pro', 'gemini-pro', 0),
(4, 'Mistral', 'Mistral 7B', 'mistral-7b', 1),
(5, 'Meta', 'LLaMA 3', 'llama-3', 1);


INSERT INTO usuarios (usuario_id, email, password_hash, nombre, fecha_registro, ultimo_acceso, imagen_url) VALUES
(1, 'usuario1@example.com', 'hashed_pass_1', 'Juan Pérez', '2024-01-10 10:00:00', '2025-06-20 14:30:00', 'https://example.com/img1.jpg'),
(2, 'usuario2@example.com', 'hashed_pass_2', 'Ana Gómez', '2024-03-15 15:45:00', '2025-06-25 09:00:00', 'https://example.com/img2.jpg'),
(3, 'user3@test.com', 'hashed_pass_3', 'Carlos Ruiz', '2024-05-05 12:00:00', '2025-06-24 11:15:00', 'https://example.com/img3.jpg'),
(4, 'user4@test.com', 'hashed_pass_4', 'Luisa Mendoza', '2024-06-01 08:30:00', '2025-06-23 18:00:00', 'https://example.com/img4.jpg'),
(5, 'user5@test.com', 'hashed_pass_5', 'Miguel Ángel', '2024-02-20 19:00:00', '2025-06-21 13:00:00', 'https://example.com/img5.jpg');


INSERT INTO preferencias_usuario (usuario_id, modelo_ia_default_id) VALUES
(1, 1),
(2, 2),
(3, 1),
(4, 4),
(5, 5);


INSERT INTO conversaciones (conversacion_id, usuario_id, modelo_ia_id, titulo, fecha_creacion, ultima_actualizacion) VALUES
(1, 1, 1, 'Ayuda con SQL', '2025-06-24 10:00:00', '2025-06-24 10:05:00'),
(2, 2, 2, 'Consejos de viaje', '2025-06-23 16:00:00', '2025-06-23 16:20:00'),
(3, 3, 1, 'Receta de cocina', '2025-06-22 18:00:00', '2025-06-22 18:30:00'),
(4, 4, 4, 'Ideas para proyecto final', '2025-06-21 14:00:00', '2025-06-21 14:25:00'),
(5, 5, 5, 'Ayuda con tareas', '2025-06-20 20:00:00', '2025-06-20 20:15:00'),
(6, 1, 1, 'Planificación de vacaciones', '2025-06-24 11:00:00', '2025-06-24 11:10:00');


INSERT INTO mensajes (mensaje_id, conversacion_id, remitente, contenido_texto, timestamp_envio) VALUES
(1, 1, 'usuario', '¿Cómo hago una JOIN en SQL?', '2025-06-24 10:00:05'),
(2, 1, 'ia', 'Puedes usar INNER JOIN o LEFT JOIN dependiendo del caso.', '2025-06-24 10:00:10'),
(3, 2, 'usuario', '¿Cuándo es mejor ir a Japón?', '2025-06-23 16:00:05'),
(4, 2, 'ia', 'Primavera es una excelente opción.', '2025-06-23 16:00:30'),
(5, 3, 'usuario', 'Quiero hacer arroz chaufa.', '2025-06-22 18:01:00'),
(6, 3, 'ia', 'Te recomiendo pollo, arroz, sillao y cebolla china.', '2025-06-22 18:01:30'),
(7, 4, 'usuario', 'Dame ideas para un proyecto con Flutter.', '2025-06-21 14:01:00'),
(8, 4, 'ia', 'Una app para gestión de notas puede ser útil.', '2025-06-21 14:02:00'),
(9, 5, 'usuario', 'Explícame álgebra lineal.', '2025-06-20 20:01:00'),
(10, 5, 'ia', 'Claro, ¿qué tema te interesa más?', '2025-06-20 20:01:20'),
(11, 6, 'usuario', '¿Qué lugares visitar en Cusco?', '2025-06-24 11:01:00'),
(12, 6, 'ia', 'Machu Picchu, Sacsayhuamán, Valle Sagrado...', '2025-06-24 11:01:25');
