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

  @override
  void initState() {
    super.initState();

    _profesionales = _service.obtenerPorEspecialidad(
      widget.especialidadId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.especialidadNombre),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      body: FutureBuilder<List<Profesional>>(
        future: _profesionales,

        builder: (context, snapshot) {

          if (snapshot.connectionState ==
              ConnectionState.waiting) {

            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {

            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment:
                  MainAxisAlignment.center,

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
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 15),

                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _profesionales =
                              _service.obtenerPorEspecialidad(
                                widget.especialidadId,
                              );
                        });
                      },
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            );
          }

          final profesionales = snapshot.data ?? [];

          if (profesionales.isEmpty) {

            return const Center(
              child: Padding(
                padding: EdgeInsets.all(20),

                child: Column(
                  mainAxisAlignment:
                  MainAxisAlignment.center,

                  children: [

                    Icon(
                      Icons.person_off,
                      size: 70,
                      color: Colors.grey,
                    ),

                    SizedBox(height: 15),

                    Text(
                      'No hay profesionales disponibles para esta especialidad.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),

            itemCount: profesionales.length,

            itemBuilder: (context, index) {

              final profesional =
              profesionales[index];

              return Card(
                margin: const EdgeInsets.only(
                  bottom: 12,
                ),

                elevation: 3,

                child: ListTile(

                  contentPadding:
                  const EdgeInsets.all(16),

                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),

                  title: Text(
                    profesional.nombre,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  subtitle: Padding(
                    padding:
                    const EdgeInsets.only(top: 8),

                    child: Text(
                      profesional
                          .informacionProfesional,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),

                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}