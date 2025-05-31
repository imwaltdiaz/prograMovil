import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  final List<Map<String, String>> _conversations = const [
    {'title': 'Ayuda con mate', 'date': 'Hace 2 días'},
    {'title': 'Plan de viaje', 'date': '14/04/2025'},
    {'title': 'Receta de pizza', 'date': '10/04/2025'},
    {'title': 'Problema física', 'date': '05/04/2025'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF5F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDF5F7),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text(
          'Conversaciones',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontFamily: 'Roboto',
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _conversations.length,
        itemBuilder: (context, index) {
          final conversation = _conversations[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF1F3),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: ListTile(
              title: Text(
                conversation['title']!,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                  fontSize: 16,
                  fontFamily: 'Roboto',
                ),
              ),
              subtitle: Text(
                conversation['date']!,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                  fontFamily: 'Roboto',
                ),
              ),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Abrir: ${conversation['title']}')),
                );
              },
            ),
          );
        },
      ),
    );
  }
} 
