import 'package:flutter/material.dart';

import '../models/especialidad.dart';
import '../services/especialidad_service.dart';
import 'profesionales_screen.dart';

class EspecialidadesScreen extends StatefulWidget {
  const EspecialidadesScreen({super.key});

  @override
  State<EspecialidadesScreen> createState() =>
      _EspecialidadesScreenState();
}

class _EspecialidadesScreenState
    extends State<EspecialidadesScreen> {

  final EspecialidadService _service =
  EspecialidadService();

  late Future<List<Especialidad>> _especialidades;

  @override
  void initState() {
    super.initState();

    _especialidades =
        _service.obtenerEspecialidades();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Especialidades médicas',
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      body: FutureBuilder<List<Especialidad>>(
        future: _especialidades,

        builder: (context, snapshot) {

          // Cargando
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Error
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
                      'No fue posible consultar las especialidades.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 15),

                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _especialidades =
                              _service
                                  .obtenerEspecialidades();
                        });
                      },
                      child: const Text(
                        'Reintentar',
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final especialidades =
              snapshot.data ?? [];

          // Sin especialidades
          if (especialidades.isEmpty) {
            return const Center(
              child: Text(
                'No hay especialidades médicas disponibles.',
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
            );
          }

          // Lista de especialidades
          return ListView.builder(
            padding: const EdgeInsets.all(16),

            itemCount: especialidades.length,

            itemBuilder: (context, index) {

              final especialidad =
              especialidades[index];

              return Card(
                margin: const EdgeInsets.only(
                  bottom: 12,
                ),

                elevation: 3,

                child: ListTile(
                  contentPadding:
                  const EdgeInsets.all(16),

                  leading: CircleAvatar(
                    backgroundColor:
                    Colors.blue,

                    child: const Icon(
                      Icons.medical_services,
                      color: Colors.white,
                    ),
                  ),

                  title: Text(
                    especialidad.nombre,

                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  subtitle: Padding(
                    padding:
                    const EdgeInsets.only(top: 8),

                    child: Text(
                      especialidad.descripcion,
                    ),
                  ),

                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                  ),

                  onTap: () {
                    Navigator.push(
                      context,

                      MaterialPageRoute(
                        builder: (context) =>
                            ProfesionalesScreen(
                              especialidadId:
                              especialidad.id,

                              especialidadNombre:
                              especialidad.nombre,
                            ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}