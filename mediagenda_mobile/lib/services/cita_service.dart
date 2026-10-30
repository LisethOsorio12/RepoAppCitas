
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/cita.dart';

class CitaService {
  // Dirección del backend Quarkus desde el emulador Android.
  final String baseUrl = 'http://10.0.2.2:8080/api/citas';

  // Identificador temporal del paciente de prueba.
  // Se reemplazará cuando implementemos el inicio de sesión.
  static const int pacienteIdPrueba = 1;

  // 1. Consultar las citas futuras y vigentes del paciente.
  Future<List<Cita>> listarCitasPaciente(int pacienteId) async {
    final url = Uri.parse('$baseUrl/paciente/$pacienteId');

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> datos = jsonDecode(response.body);

        return datos
            .map((json) => Cita.fromJson(json))
            .toList();
      }

      throw Exception(
        'Error al consultar las citas. '
            'Código: ${response.statusCode}. '
            '${response.body}',
      );
    } catch (e) {
      throw Exception('No fue posible consultar las citas: $e');
    }
  }

  // 2. Consultar los horarios disponibles para reprogramar una cita.
  Future<List<DateTime>> consultarHorariosDisponibles({
    required int citaId,
    required int pacienteId,
    required DateTime fecha,
  }) async {
    final String fechaTexto =
        '${fecha.year.toString().padLeft(4, '0')}-'
        '${fecha.month.toString().padLeft(2, '0')}-'
        '${fecha.day.toString().padLeft(2, '0')}';

    final url = Uri.parse(
      '$baseUrl/$citaId/horarios-disponibles',
    ).replace(
      queryParameters: {
        'pacienteId': pacienteId.toString(),
        'fecha': fechaTexto,
      },
    );

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> datos = jsonDecode(response.body);

        return datos
            .map((hora) => DateTime.parse(hora.toString()))
            .toList();
      }

      throw Exception(
        'Error al consultar los horarios. '
            'Código: ${response.statusCode}. '
            '${response.body}',
      );
    } catch (e) {
      throw Exception('No fue posible consultar los horarios: $e');
    }
  }

  // 3. Reprogramar una cita con la nueva fecha y hora.
  Future<Cita> reprogramarCita({
    required int citaId,
    required int pacienteId,
    required DateTime nuevaFechaHora,
  }) async {
    final url = Uri.parse('$baseUrl/$citaId/reprogramar');

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'pacienteId': pacienteId,
          'nuevaFechaHora': nuevaFechaHora.toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> datos =
        jsonDecode(response.body);

        return Cita.fromJson(datos);
      }

      throw Exception(
        'Error al reprogramar la cita. '
            'Código: ${response.statusCode}. '
            '${response.body}',
      );
    } catch (e) {
      throw Exception('No fue posible reprogramar la cita: $e');
    }
  }
}
