
class Cita {
  final int id;
  final int pacienteId;
  final int profesionalId;
  final String profesionalNombre;
  final String especialidadNombre;
  final DateTime fechaHora;
  final String estado;

  Cita({
    required this.id,
    required this.pacienteId,
    required this.profesionalId,
    required this.profesionalNombre,
    required this.especialidadNombre,
    required this.fechaHora,
    required this.estado,
  });

  factory Cita.fromJson(Map<String, dynamic> json) {
    return Cita(
      id: json['id'],
      pacienteId: json['pacienteId'],
      profesionalId: json['profesionalId'],
      profesionalNombre: json['profesionalNombre'] ?? '',
      especialidadNombre: json['especialidadNombre'] ?? '',
      fechaHora: DateTime.parse(json['fechaHora']),
      estado: json['estado'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pacienteId': pacienteId,
      'profesionalId': profesionalId,
      'profesionalNombre': profesionalNombre,
      'especialidadNombre': especialidadNombre,
      'fechaHora': fechaHora.toIso8601String(),
      'estado': estado,
    };
  }
}
