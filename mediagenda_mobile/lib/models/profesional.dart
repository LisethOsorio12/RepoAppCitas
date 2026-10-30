
class Profesional {
  final int id;
  final String nombre;
  final String informacionProfesional;
  final bool activo;
  final bool disponible;

  Profesional({
    required this.id,
    required this.nombre,
    required this.informacionProfesional,
    required this.activo,
    required this.disponible,
  });

  factory Profesional.fromJson(Map<String, dynamic> json) {
    return Profesional(
      id: (json['id'] as num).toInt(),
      nombre: json['nombre'] as String,
      informacionProfesional:
      json['informacionProfesional'] as String,
      activo: json['activo'] as bool,
      disponible: json['disponible'] as bool,
    );
  }
}
