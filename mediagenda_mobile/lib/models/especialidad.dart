class Especialidad {
  final int id;
  final String nombre;
  final String descripcion;
  final bool activa;

  Especialidad({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.activa,
  });

  factory Especialidad.fromJson(Map<String, dynamic> json) {
    return Especialidad(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String,
      activa: json['activa'] as bool,
    );
  }
}