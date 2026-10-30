
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/especialidad.dart';

class EspecialidadService {
  static const String baseUrl =
      'http://10.0.2.2:8080/api/especialidades';

  Future<List<Especialidad>> obtenerEspecialidades() async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 15));

      // Información para diagnosticar la petición
      print('========== CONSULTA DE ESPECIALIDADES ==========');
      print('URL: $baseUrl');
      print('Código de respuesta: ${response.statusCode}');
      print('Headers: ${response.headers}');
      print('Respuesta del servidor: ${response.body}');
      print('================================================');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        return data
            .map((json) => Especialidad.fromJson(json))
            .toList();
      } else {
        throw Exception(
          'Error del servidor: ${response.statusCode}. '
              'Respuesta: ${response.body}',
        );
      }
    } catch (e) {
      print('ERROR AL CONSULTAR ESPECIALIDADES: $e');

      throw Exception(
        'No se pudieron consultar las especialidades: $e',
      );
    }
  }
}
