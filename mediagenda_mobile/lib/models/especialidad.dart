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
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      activa: json['activa'],
    );
  }
}