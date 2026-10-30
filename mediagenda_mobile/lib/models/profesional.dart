class Profesional {
  final int id;
  final String nombre;
  final String informacionProfesional;
  final bool activo;
  final int especialidadId;

  Profesional({
    required this.id,
    required this.nombre,
    required this.informacionProfesional,
    required this.activo,
    required this.especialidadId,
  });

  factory Profesional.fromJson(Map<String, dynamic> json) {
    return Profesional(
      id: json['id'],
      nombre: json['nombre'],
      informacionProfesional: json['informacionProfesional'],
      activo: json['activo'],
      especialidadId: json['especialidadId'],
    );
  }
}