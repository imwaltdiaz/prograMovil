import 'package:flutter/material.dart';
import 'preferences_layout.dart';

class PreferencesPage extends StatefulWidget {
  const PreferencesPage({super.key});

  @override
  State<PreferencesPage> createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  // Variables de estado local
  ThemeMode _themeMode = ThemeMode.light;
  bool _notiNewMessages = true;
  bool _notiUpdates = false;

  void _changeTheme(ThemeMode? mode) {
    if (mode != null) {
      setState(() {
        _themeMode = mode;
    });
  }
}


  void _toggleNotification(String type, bool value) {
    setState(() {
      if (type == 'messages') _notiNewMessages = value;
      if (type == 'updates') _notiUpdates = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: PreferencesLayout(
        themeMode: _themeMode,
        notiNewMessages: _notiNewMessages,
        notiUpdates: _notiUpdates,
        onThemeChange: _changeTheme,
        onToggleNotification: _toggleNotification,
      ),
    );
  }
}
