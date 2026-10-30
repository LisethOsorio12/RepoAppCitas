
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

  final EspecialidadService _service = EspecialidadService();

  late Future<List<Especialidad>> _especialidades;

  final TextEditingController _busquedaController =
  TextEditingController();

  String _textoBusqueda = '';

  static const Color azulPrincipal = Color(0xFF1688E8);
  static const Color fondo = Color(0xFFF5F8FD);
  static const Color textoOscuro = Color(0xFF17243A);

  @override
  void initState() {
    super.initState();
    _especialidades = _service.obtenerEspecialidades();
  }

  @override
  void dispose() {
    _busquedaController.dispose();
    super.dispose();
  }

  IconData obtenerIcono(String nombre) {
    switch (nombre.toLowerCase()) {
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

  Color obtenerColor(String nombre) {
    switch (nombre.toLowerCase()) {
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

  Color obtenerColorIcono(String nombre) {
    switch (nombre.toLowerCase()) {
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

  Future<void> cargarEspecialidades() async {
    setState(() {
      _especialidades = _service.obtenerEspecialidades();
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
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: azulPrincipal,
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: FutureBuilder<List<Especialidad>>(
        future: _especialidades,

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
                      size: 55,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'No fue posible consultar las especialidades.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: cargarEspecialidades,
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            );
          }

          final especialidades = snapshot.data ?? [];

          final filtradas = especialidades.where((especialidad) {
            return especialidad.nombre
                .toLowerCase()
                .contains(_textoBusqueda.toLowerCase());
          }).toList();

          if (especialidades.isEmpty) {
            return const Center(
              child: Text(
                'No hay especialidades médicas disponibles.',
              ),
            );
          }

          return Column(
            children: [

              // Buscador
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
                child: TextField(
                  controller: _busquedaController,
                  onChanged: (valor) {
                    setState(() {
                      _textoBusqueda = valor;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Buscar especialidad...',
                    hintStyle: const TextStyle(
                      color: Color(0xFF71829A),
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color(0xFF60758F),
                    ),
                    suffixIcon: _textoBusqueda.isNotEmpty
                        ? IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        _busquedaController.clear();
                        setState(() {
                          _textoBusqueda = '';
                        });
                      },
                    )
                        : null,
                    filled: true,
                    fillColor: const Color(0xFFE9F0F9),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 17,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: const BorderSide(
                        color: azulPrincipal,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),

              // Lista de especialidades
              Expanded(
                child: filtradas.isEmpty
                    ? const Center(
                  child: Text(
                    'No se encontraron especialidades.',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  ),
                )
                    : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(
                    16, 8, 16, 20,
                  ),
                  itemCount: filtradas.length,
                  itemBuilder: (context, index) {

                    final especialidad = filtradas[index];

                    return Container(
                      margin: const EdgeInsets.only(
                        bottom: 13,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
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
                          horizontal: 15,
                          vertical: 13,
                        ),

                        leading: CircleAvatar(
                          radius: 31,
                          backgroundColor:
                          obtenerColor(especialidad.nombre),
                          child: Icon(
                            obtenerIcono(especialidad.nombre),
                            color: obtenerColorIcono(
                                especialidad.nombre),
                            size: 28,
                          ),
                        ),

                        title: Text(
                          especialidad.nombre,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textoOscuro,
                          ),
                        ),

                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 7),
                          child: Text(
                            especialidad.descripcion,
                            style: const TextStyle(
                              fontSize: 13,
                              height: 1.4,
                              color: Color(0xFF526782),
                            ),
                          ),
                        ),

                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: Color(0xFF60758F),
                          size: 19,
                        ),

                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProfesionalesScreen(
                                    especialidadId: especialidad.id,
                                    especialidadNombre:
                                    especialidad.nombre,
                                  ),
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
