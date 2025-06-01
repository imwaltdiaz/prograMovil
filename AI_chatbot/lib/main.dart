import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import './configs/theme_1.dart';
import './configs/util.dart';

import './pages/register/register.dart';
import './pages/login/login.dart';
import './pages/preferences/preferences_page.dart';
import './pages/History/HistoryPage.dart';
import 'package:intl/intl.dart';
import './pages/Chat/chat_page.dart';
import './pages/profile/profile_page.dart';

void main() => runApp(const MyApp());

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

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Hello World',
        theme: materialTheme.light(),
        darkTheme: materialTheme.dark(),
        themeMode: ThemeMode.system,
        initialRoute: '/login', // Ruta inicial
        // Establece el soporte de localización de tu app
        localizationsDelegates: [
          GlobalMaterialLocalizations
              .delegate, // Delegado para material widgets
          GlobalCupertinoLocalizations.delegate, // Delegado para iOS
          GlobalWidgetsLocalizations
              .delegate, // Delegado para widgets generales
        ],
        supportedLocales: const [
          Locale('en', 'US'), // Inglés
          Locale('es', 'ES'), // Español
          // Agregar otros idiomas si lo necesitas
        ],
        locale: const Locale('es', 'ES'),
        routes: {
          '/register': (context) => RegisterPage(),
          '/login': (context) => LoginPage(),
          '/preferences': (context) => PreferencesPage(),
          '/history': (context) => HistoryPage(),
          '/chat': (context) => ChatPage(),
          '/profile': (context) => ProfilePage(),
          '/evaluation': (context) => EvaluationPage(), 

        });
  }
}
