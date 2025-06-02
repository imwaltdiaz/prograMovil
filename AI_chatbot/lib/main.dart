// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart'; // Import de GetX

// Importa tu archivo de tema y utilitarios
import './configs/theme_1.dart';
import './configs/util.dart';

// Importa todas tus páginas
import './pages/register/register.dart';
import './pages/login/login.dart';
import './pages/preferences/preferences_page.dart';
import './pages/History/HistoryPage.dart';
import './pages/evaluation/evaluation.dart';
import 'package:intl/intl.dart';
import './pages/Chat/chat_page.dart';
import './pages/profile/profile_page.dart';
import './pages/compartir/compartir.dart';
import './pages/configuracionAI/configuracionAI_page.dart';
import './pages/privacidad/privacy_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme =
        createTextTheme(context, 'Abril Fatface', 'Allerta');
    final MaterialTheme materialTheme = MaterialTheme(textTheme);

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Hello World',

      // ─── Temas ───────────────────────────────────────────────────────────────
      theme: materialTheme.light(),
      darkTheme: materialTheme.dark(),
      themeMode: ThemeMode.system,

      // ─── Localización ────────────────────────────────────────────────────────
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('es', 'ES'),
      ],
      locale: const Locale('es', 'ES'),

      // ─── Ruta inicial ─────────────────────────────────────────────────────────
      initialRoute: '/login',

      // ─── Definición de rutas usando GetPage ─────────────────────────────────
      getPages: [
        GetPage(name: '/login', page: () => const LoginPage()),
        GetPage(name: '/register', page: () => const RegisterPage()),
        GetPage(name: '/preferences', page: () => const PreferencesPage()),
        GetPage(name: '/history', page: () => const HistoryPage()),
        GetPage(name: '/chat', page: () => const ChatPage()),
        GetPage(name: '/profile', page: () => const ProfilePage()),
        GetPage(name: '/evaluation', page: () => const EvaluationPage()),
        GetPage(name: '/compartir', page: () => const CompartirPage()),
        GetPage(name: '/configuracionAI', page: () => const AIConfigPage()),
        GetPage(name: '/privacidad', page: () => const PrivacyPage()),
      ],
    );
  }
}
