
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/profesional.dart';

class ProfesionalService {
  static const String baseUrl =
      'http://10.0.2.2:8080/api/profesionales';

  Future<List<Profesional>> obtenerPorEspecialidad(
      int especialidadId) async {
    try {
      final url = '$baseUrl/especialidad/$especialidadId';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 15));

      print('========== CONSULTA DE PROFESIONALES ==========');
      print('URL: $url');
      print('Código de respuesta: ${response.statusCode}');
      print('Respuesta: ${response.body}');
      print('================================================');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        return data
            .map((json) => Profesional.fromJson(json))
            .toList();
      } else {
        throw Exception(
          'Error ${response.statusCode}: ${response.body}',
        );
      }
    } catch (e) {
      print('ERROR AL CONSULTAR PROFESIONALES: $e');
      throw Exception('No fue posible consultar los profesionales: $e');
    }
  }
}
