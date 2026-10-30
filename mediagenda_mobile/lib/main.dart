import 'package:flutter/material.dart';
import 'screens/especialidades_screen.dart';

void main() {
  runApp(const MediAgendaApp());
}

class MediAgendaApp extends StatelessWidget {
  const MediAgendaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'MediAgenda',

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),

        useMaterial3: true,
      ),

      home: const EspecialidadesScreen(),
    );
  }
}