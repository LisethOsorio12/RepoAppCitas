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
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        return data
            .map((json) => Especialidad.fromJson(json))
            .toList();
      } else {
        throw Exception(
          'Error del servidor: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception(
        'No se pudo conectar con el servidor: $e',
      );
    }
  }
}