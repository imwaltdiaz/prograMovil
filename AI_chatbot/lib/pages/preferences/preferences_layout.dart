/*import 'package:flutter/material.dart';
import '../History/HistoryPage.dart'; // Importar la página de historial

class PreferencesLayout extends StatelessWidget {
  final ThemeMode themeMode;
  final bool notiNewMessages;
  final bool notiUpdates;
  final Function(ThemeMode?) onThemeChange;
  final Function(String, bool) onToggleNotification;

  const PreferencesLayout({
    super.key,
    required this.themeMode,
    required this.notiNewMessages,
    required this.notiUpdates,
    required this.onThemeChange,
    required this.onToggleNotification,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Perfil', style: TextStyle(fontWeight: FontWeight.bold)),
        ListTile(
          title: const Text('Editar información'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            // Navegar a pantalla de edición de perfil
          },
        ),
        ListTile(
          title: const Text('Historial de chat'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HistoryPage()),
            );
          },
        ),
        const Divider(),
        const Text('Apariencia', style: TextStyle(fontWeight: FontWeight.bold)),
        RadioListTile(
          title: const Text('Tema claro'),
          value: ThemeMode.light,
          groupValue: themeMode,
          onChanged: onThemeChange,
        ),
        RadioListTile(
          title: const Text('Tema oscuro'),
          value: ThemeMode.dark,
          groupValue: themeMode,
          onChanged: onThemeChange,
        ),
        const Divider(),
        const Text('Chatbot', style: TextStyle(fontWeight: FontWeight.bold)),
        ListTile(
          title: const Text('Estilo de respuesta'),
          trailing: const Icon(Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey), // Opcional: ajustar tamaño y color del ícono
          onTap: () {
            // Usar Navigator.pushNamed para ir a la ruta especificada
            Navigator.pushNamed(context, '/configuracionAI');
          },
          // Opcional: añadir algo de padding o ajustar la densidad si es necesario
          // contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          // dense: true,
        ),
        ListTile(
          title: const Text('Longitud preferida'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {},
        ),
        const Divider(),
        const Text('Notificaciones',
            style: TextStyle(fontWeight: FontWeight.bold)),
        CheckboxListTile(
          title: const Text('Mensajes nuevos'),
          value: notiNewMessages,
          onChanged: (val) => onToggleNotification('messages', val ?? false),
        ),
        CheckboxListTile(
          title: const Text('Actualizaciones'),
          value: notiUpdates,
          onChanged: (val) => onToggleNotification('updates', val ?? false),
        ),
      ],
    );
  }
}*/
