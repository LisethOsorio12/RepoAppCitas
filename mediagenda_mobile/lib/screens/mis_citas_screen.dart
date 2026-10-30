
import 'package:flutter/material.dart';

import '../models/cita.dart';
import '../services/cita_service.dart';

class MisCitasScreen extends StatefulWidget {
  const MisCitasScreen({super.key});

  @override
  State<MisCitasScreen> createState() => _MisCitasScreenState();
}

class _MisCitasScreenState extends State<MisCitasScreen> {
  final CitaService citaService = CitaService();
  final int pacienteId = CitaService.pacienteIdPrueba;

  late Future<List<Cita>> futurasCitas;

  static const Color azul = Color(0xFF123F65);
  static const Color fondo = Color(0xFFF3F8FC);

  @override
  void initState() {
    super.initState();
    futurasCitas = citaService.listarCitasPaciente(pacienteId);
  }

  Future<void> recargarCitas() async {
    setState(() {
      futurasCitas = citaService.listarCitasPaciente(pacienteId);
    });
    await futurasCitas;
  }

  String formatearFecha(DateTime fecha) {
    const meses = [
      'enero', 'febrero', 'marzo', 'abril',
      'mayo', 'junio', 'julio', 'agosto',
      'septiembre', 'octubre', 'noviembre', 'diciembre'
    ];

    return '${fecha.day} de ${meses[fecha.month - 1]} de ${fecha.year}';
  }

  String formatearHora(DateTime fecha) {
    final hora = fecha.hour;
    final minutos = fecha.minute.toString().padLeft(2, '0');
    final periodo = hora >= 12 ? 'p. m.' : 'a. m.';
    final hora12 = hora % 12 == 0 ? 12 : hora % 12;

    return '$hora12:$minutos $periodo';
  }

  Future<void> abrirReprogramacion(Cita cita) async {
    final resultado = await Navigator.pushNamed(
      context,
      '/reprogramar-cita',
      arguments: cita,
    );

    if (resultado == true && mounted) {
      await recargarCitas();
    }
  }

  Map<String, dynamic> estiloEspecialidad(String especialidad) {
    final nombre = especialidad.toLowerCase();

    if (nombre.contains('cardio')) {
      return {
        'icono': Icons.favorite,
        'color': const Color(0xFFFF6474),
        'fondo': const Color(0xFFFFE9EC),
      };
    }

    if (nombre.contains('dermato')) {
      return {
        'icono': Icons.back_hand,
        'color': const Color(0xFF26B7B0),
        'fondo': const Color(0xFFE1F8F5),
      };
    }

    if (nombre.contains('pedia')) {
      return {
        'icono': Icons.child_care,
        'color': const Color(0xFF8B6BEA),
        'fondo': const Color(0xFFF0EAFE),
      };
    }

    return {
      'icono': Icons.medical_services,
      'color': const Color(0xFF27B879),
      'fondo': const Color(0xFFE3F8ED),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,
      appBar: AppBar(
        backgroundColor: azul,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 52,
        title: const Text(
          'Mis citas médicas',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: FutureBuilder<List<Cita>>(
        future: futurasCitas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: azul),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.redAccent,
                      size: 50,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'No fue posible cargar tus citas.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: azul,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: recargarCitas,
                      child: const Text('Intentar nuevamente'),
                    ),
                  ],
                ),
              ),
            );
          }

          final citas = snapshot.data ?? [];

          if (citas.isEmpty) {
            return RefreshIndicator(
              onRefresh: recargarCitas,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 150),
                  Icon(
                    Icons.calendar_month_outlined,
                    size: 65,
                    color: azul,
                  ),
                  SizedBox(height: 15),
                  Center(
                    child: Text(
                      'No tienes citas vigentes.',
                      style: TextStyle(
                        color: azul,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: recargarCitas,
            color: azul,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(14, 13, 14, 25),
              children: [
                const Text(
                  'Tus próximas citas',
                  style: TextStyle(
                    color: azul,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  'Consulta los detalles de tus citas y modifica '
                      'la fecha u hora cuando lo necesites.',
                  style: TextStyle(
                    color: Color(0xFF607D91),
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 13),

                ...citas.map((cita) => tarjetaCita(cita)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget tarjetaCita(Cita cita) {
    final estilo = estiloEspecialidad(cita.especialidadNombre);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: const Color(0xFFE8EEF4),
          width: 0.7,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 39,
                height: 39,
                decoration: BoxDecoration(
                  color: estilo['fondo'],
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  estilo['icono'],
                  color: estilo['color'],
                  size: 23,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cita.especialidadNombre,
                      style: const TextStyle(
                        color: azul,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      cita.profesionalNombre,
                      style: const TextStyle(
                        color: Color(0xFF607D91),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          const Divider(
            height: 1,
            color: Color(0xFFDCE4EC),
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                color: azul,
                size: 14,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  formatearFecha(cita.fechaHora),
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF263746),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 7),

          Row(
            children: [
              const Icon(
                Icons.access_time,
                color: azul,
                size: 14,
              ),
              const SizedBox(width: 8),
              Text(
                formatearHora(cita.fechaHora),
                style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFF263746),
                ),
              ),
            ],
          ),

          const SizedBox(height: 9),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F8EA),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  cita.estado,
                  style: const TextStyle(
                    color: Color(0xFF238342),
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              ElevatedButton.icon(
                onPressed: () => abrirReprogramacion(cita),
                icon: const Icon(
                  Icons.edit_calendar,
                  size: 14,
                ),
                label: const Text(
                  'Reprogramar',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: azul,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  minimumSize: const Size(0, 33),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 7,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
