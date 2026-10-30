import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/profesional.dart';

class ProfesionalService {
  static const String baseUrl =
      'http://10.0.2.2:8080/api/profesionales';

  Future<List<Profesional>> obtenerPorEspecialidad(
      int especialidadId) async {

    final response = await http.get(
      Uri.parse('$baseUrl/especialidad/$especialidadId'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data
          .map((json) => Profesional.fromJson(json))
          .toList();
    } else {
      throw Exception(
        'Error al consultar los profesionales',
      );
    }
  }
}