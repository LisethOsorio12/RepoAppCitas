
import 'package:flutter/material.dart';

import 'screens/especialidades_screen.dart';
import 'screens/mis_citas_screen.dart';
import 'screens/reprogramar_cita_screen.dart';
import 'models/cita.dart';

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

      routes: {
        '/mis-citas': (context) => const MisCitasScreen(),

        '/reprogramar-cita': (context) {
          final cita = ModalRoute.of(context)!.settings.arguments as Cita;

          return ReprogramarCitaScreen(
            cita: cita,
          );
        },
      },
    );
  }
}
