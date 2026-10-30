
import 'package:flutter/material.dart';

import '../models/profesional.dart';
import '../services/profesional_service.dart';

class ProfesionalesScreen extends StatefulWidget {
  final int especialidadId;
  final String especialidadNombre;

  const ProfesionalesScreen({
    super.key,
    required this.especialidadId,
    required this.especialidadNombre,
  });

  @override
  State<ProfesionalesScreen> createState() =>
      _ProfesionalesScreenState();
}

class _ProfesionalesScreenState
    extends State<ProfesionalesScreen> {

  final ProfesionalService _service = ProfesionalService();

  late Future<List<Profesional>> _profesionales;

  static const Color azulPrincipal = Color(0xFF1688E8);
  static const Color fondo = Color(0xFFF5F8FD);
  static const Color textoOscuro = Color(0xFF17243A);

  @override
  void initState() {
    super.initState();

    _profesionales = _service.obtenerPorEspecialidad(
      widget.especialidadId,
    );
  }

  IconData obtenerIconoEspecialidad() {
    switch (widget.especialidadNombre.toLowerCase()) {
      case 'cardiología':
        return Icons.favorite;
      case 'dermatología':
        return Icons.back_hand;
      case 'pediatría':
        return Icons.child_care;
      case 'medicina general':
        return Icons.medical_services;
      default:
        return Icons.health_and_safety;
    }
  }

  Color obtenerColorEspecialidad() {
    switch (widget.especialidadNombre.toLowerCase()) {
      case 'cardiología':
        return const Color(0xFFE94359);
      case 'dermatología':
        return const Color(0xFF21B5CF);
      case 'pediatría':
        return const Color(0xFF7950E8);
      case 'medicina general':
        return const Color(0xFF20A66B);
      default:
        return azulPrincipal;
    }
  }

  Color obtenerFondoEspecialidad() {
    switch (widget.especialidadNombre.toLowerCase()) {
      case 'cardiología':
        return const Color(0xFFFFDCE2);
      case 'dermatología':
        return const Color(0xFFD9F5FA);
      case 'pediatría':
        return const Color(0xFFE8DEFF);
      case 'medicina general':
        return const Color(0xFFD8F4E6);
      default:
        return const Color(0xFFE1EDFF);
    }
  }

  String obtenerDescripcionEspecialidad() {
    switch (widget.especialidadNombre.toLowerCase()) {
      case 'cardiología':
        return 'Especialidad médica relacionada con el corazón.';
      case 'dermatología':
        return 'Especialidad médica relacionada con la piel.';
      case 'pediatría':
        return 'Atención médica especializada para niños.';
      case 'medicina general':
        return 'Atención médica integral y preventiva.';
      default:
        return 'Consulta los profesionales de esta especialidad.';
    }
  }

  Future<void> cargarProfesionales() async {
    setState(() {
      _profesionales = _service.obtenerPorEspecialidad(
        widget.especialidadId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,

      appBar: AppBar(
        title: const Text(
          'Especialidades médicas',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: azulPrincipal,
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: FutureBuilder<List<Profesional>>(
        future: _profesionales,

        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: azulPrincipal,
              ),
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
                      size: 60,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'No fue posible consultar los profesionales.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: cargarProfesionales,
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            );
          }

          final profesionales = snapshot.data ?? [];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Información de la especialidad
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 25, 20, 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    CircleAvatar(
                      radius: 43,
                      backgroundColor: obtenerFondoEspecialidad(),
                      child: Icon(
                        obtenerIconoEspecialidad(),
                        size: 39,
                        color: obtenerColorEspecialidad(),
                      ),
                    ),

                    const SizedBox(width: 18),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.especialidadNombre,
                            style: const TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                              color: textoOscuro,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            obtenerDescripcionEspecialidad(),
                            style: const TextStyle(
                              fontSize: 13,
                              height: 1.5,
                              color: Color(0xFF526782),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Título de profesionales
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 15),
                child: const Text(
                  'Profesionales disponibles',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textoOscuro,
                  ),
                ),
              ),

              // Mensaje cuando no hay profesionales
              if (profesionales.isEmpty)
                const Expanded(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person_off_outlined,
                            size: 65,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 15),
                          Text(
                            'No hay profesionales disponibles para esta especialidad.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: textoOscuro,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // Lista de profesionales
              if (profesionales.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      16, 0, 16, 20,
                    ),
                    itemCount: profesionales.length,

                    itemBuilder: (context, index) {

                      final profesional = profesionales[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),

                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(21),
                          border: Border.all(
                            color: const Color(0xFFE9EFF7),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blueGrey.withOpacity(0.05),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),

                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),

                          leading: CircleAvatar(
                            radius: 34,
                            backgroundColor: const Color(0xFFE2F0FF),
                            child: const Icon(
                              Icons.person,
                              color: Color(0xFF2689D8),
                              size: 38,
                            ),
                          ),

                          title: Text(
                            profesional.nombre,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textoOscuro,
                            ),
                          ),

                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 7),
                            child: Text(
                              profesional.informacionProfesional,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF526782),
                                height: 1.4,
                              ),
                            ),
                          ),

                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 18,
                            color: Color(0xFF60758F),
                          ),

                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Perfil de ${profesional.nombre}: próximamente',
                                ),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
