
import 'package:flutter/material.dart';

import '../models/cita.dart';
import '../services/cita_service.dart';

const Color azul = Color(0xFF123F65);
const Color azulBoton = Color(0xFF0878D8);
const Color fondo = Color(0xFFF3F8FC);
const Color textoSecundario = Color(0xFF607D91);

class ReprogramarCitaScreen extends StatefulWidget {
  final Cita cita;

  const ReprogramarCitaScreen({
    super.key,
    required this.cita,
  });

  @override
  State<ReprogramarCitaScreen> createState() =>
      _ReprogramarCitaScreenState();
}

class _ReprogramarCitaScreenState
    extends State<ReprogramarCitaScreen> {
  final CitaService citaService = CitaService();

  DateTime? fechaSeleccionada;
  DateTime? horarioSeleccionado;

  List<DateTime> horariosDisponibles = [];

  bool cargandoHorarios = false;
  bool guardando = false;

  String? mensajeError;

  String formatearFecha(DateTime fecha) {
    const meses = [
      'enero', 'febrero', 'marzo', 'abril',
      'mayo', 'junio', 'julio', 'agosto',
      'septiembre', 'octubre', 'noviembre', 'diciembre'
    ];

    return '${fecha.day} de ${meses[fecha.month - 1]} de ${fecha.year}';
  }

  String formatearHora(DateTime fecha) {
    final hora = fecha.hour;
    final minutos = fecha.minute.toString().padLeft(2, '0');
    final periodo = hora >= 12 ? 'p. m.' : 'a. m.';
    final hora12 = hora % 12 == 0 ? 12 : hora % 12;

    return '$hora12:$minutos $periodo';
  }

  String horaCorta(DateTime fecha) {
    final hora = fecha.hour;
    final periodo = hora >= 12 ? 'p. m.' : 'a. m.';
    final hora12 = hora % 12 == 0 ? 12 : hora % 12;

    return '$hora12:00 $periodo';
  }

  Map<String, dynamic> estiloEspecialidad() {
    final nombre = widget.cita.especialidadNombre.toLowerCase();

    if (nombre.contains('cardio')) {
      return {
        'icono': Icons.favorite,
        'color': const Color(0xFFFF6474),
        'fondo': const Color(0xFFFFE9EC),
      };
    }

    if (nombre.contains('dermato')) {
      return {
        'icono': Icons.back_hand,
        'color': const Color(0xFF26B7B0),
        'fondo': const Color(0xFFE1F8F5),
      };
    }

    if (nombre.contains('pedia')) {
      return {
        'icono': Icons.child_care,
        'color': const Color(0xFF8B6BEA),
        'fondo': const Color(0xFFF0EAFE),
      };
    }

    return {
      'icono': Icons.medical_services,
      'color': const Color(0xFF27B879),
      'fondo': const Color(0xFFE3F8ED),
    };
  }

  Future<void> seleccionarFecha() async {
    final ahora = DateTime.now();

    DateTime siguienteDiaHabil = DateTime(
      ahora.year,
      ahora.month,
      ahora.day + 1,
    );

    while (siguienteDiaHabil.weekday == DateTime.saturday ||
        siguienteDiaHabil.weekday == DateTime.sunday) {
      siguienteDiaHabil =
          siguienteDiaHabil.add(const Duration(days: 1));
    }

    final fecha = await Navigator.push<DateTime>(
      context,
      MaterialPageRoute(
        builder: (_) => CalendarioCitasScreen(
          fechaInicial: fechaSeleccionada ?? siguienteDiaHabil,
        ),
      ),
    );

    if (fecha == null || !mounted) return;

    setState(() {
      fechaSeleccionada = fecha;
      horarioSeleccionado = null;
      horariosDisponibles = [];
      mensajeError = null;
    });

    await cargarHorarios(fecha);
  }

  Future<void> cargarHorarios(DateTime fecha) async {
    setState(() {
      cargandoHorarios = true;
      mensajeError = null;
      horariosDisponibles = [];
    });

    try {
      final horarios =
      await citaService.consultarHorariosDisponibles(
        citaId: widget.cita.id,
        pacienteId: widget.cita.pacienteId,
        fecha: fecha,
      );

      if (!mounted) return;

      setState(() {
        horariosDisponibles = horarios;
        cargandoHorarios = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        cargandoHorarios = false;
        mensajeError = e.toString();
      });
    }
  }

  Future<void> confirmarReprogramacion() async {
    if (fechaSeleccionada == null ||
        horarioSeleccionado == null ||
        guardando) {
      return;
    }

    final confirmar = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: const EdgeInsets.fromLTRB(22, 20, 22, 10),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: const BoxDecoration(
                  color: Color(0xFFE0F7E6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Color(0xFF25A34A),
                  size: 38,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Confirmar reprogramación',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: azul,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                '¿Deseas cambiar tu cita para el:',
                textAlign: TextAlign.center,
                style: TextStyle(color: textoSecundario),
              ),
              const SizedBox(height: 8),
              Text(
                formatearFecha(horarioSeleccionado!),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: azul,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'a las ${formatearHora(horarioSeleccionado!)}?',
                style: const TextStyle(
                  color: azul,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actionsPadding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
          actions: [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () =>
                        Navigator.pop(dialogContext, false),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: azul,
                      side: const BorderSide(color: azul),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9),
                      ),
                    ),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () =>
                        Navigator.pop(dialogContext, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: azul,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9),
                      ),
                    ),
                    child: const Text('Confirmar'),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );

    if (confirmar != true || !mounted) return;

    setState(() {
      guardando = true;
      mensajeError = null;
    });

    try {
      final citaActualizada =
      await citaService.reprogramarCita(
        citaId: widget.cita.id,
        pacienteId: widget.cita.pacienteId,
        nuevaFechaHora: horarioSeleccionado!,
      );

      if (!mounted) return;

      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: const BoxDecoration(
                    color: Color(0xFFDDF8E2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Color(0xFF159447),
                    size: 40,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  '¡Cita reprogramada!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: azul,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tu cita se actualizó correctamente.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: textoSecundario,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 14),
                detalleConfirmacion(
                  'Profesional',
                  citaActualizada.profesionalNombre,
                ),
                detalleConfirmacion(
                  'Especialidad',
                  citaActualizada.especialidadNombre,
                ),
                detalleConfirmacion(
                  'Fecha',
                  formatearFecha(citaActualizada.fechaHora),
                ),
                detalleConfirmacion(
                  'Hora',
                  formatearHora(citaActualizada.fechaHora),
                ),
                detalleConfirmacion(
                  'Estado',
                  citaActualizada.estado,
                ),
              ],
            ),
            actions: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () =>
                      Navigator.pop(dialogContext),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: azul,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                  child: const Text('Aceptar'),
                ),
              ),
            ],
          );
        },
      );

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        guardando = false;
        mensajeError = e.toString();
      });
    }
  }

  Widget detalleConfirmacion(String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 88,
            child: Text(
              '$titulo:',
              style: const TextStyle(
                color: azul,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              valor,
              style: const TextStyle(
                color: Color(0xFF42596B),
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget tarjetaCitaActual() {
    final estilo = estiloEspecialidad();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: estilo['fondo'],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  estilo['icono'],
                  color: estilo['color'],
                  size: 23,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.cita.especialidadNombre,
                      style: const TextStyle(
                        color: azul,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      widget.cita.profesionalNombre,
                      style: const TextStyle(
                        color: textoSecundario,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 18, color: Color(0xFFDCE5ED)),
          filaDato(
            Icons.calendar_today_outlined,
            formatearFecha(widget.cita.fechaHora),
          ),
          const SizedBox(height: 8),
          filaDato(
            Icons.access_time,
            formatearHora(widget.cita.fechaHora),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFE6F8EA),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                widget.cita.estado,
                style: const TextStyle(
                  color: Color(0xFF238342),
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget filaDato(IconData icono, String texto) {
    return Row(
      children: [
        Icon(icono, size: 16, color: azul),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            texto,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF35495A),
            ),
          ),
        ),
      ],
    );
  }

  Widget construirHorarios() {
    if (cargandoHorarios) {
      return const Padding(
        padding: EdgeInsets.all(22),
        child: Center(
          child: CircularProgressIndicator(color: azulBoton),
        ),
      );
    }

    if (mensajeError != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(
          mensajeError!,
          style: const TextStyle(
            color: Colors.red,
            fontSize: 12,
          ),
        ),
      );
    }

    if (horariosDisponibles.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFE9F1F9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.calendar_month_outlined,
              size: 38,
              color: Color(0xFF8BA3B8),
            ),
            const SizedBox(height: 10),
            Text(
              fechaSeleccionada == null
                  ? 'Primero selecciona una fecha para ver los horarios disponibles.'
                  : 'No hay horarios disponibles para esta fecha.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: textoSecundario,
                fontSize: 11,
                height: 1.5,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: horariosDisponibles.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        mainAxisExtent: 35,
      ),
      itemBuilder: (context, index) {
        final horario = horariosDisponibles[index];
        final seleccionado = horarioSeleccionado == horario;

        return InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            setState(() {
              horarioSeleccionado = horario;
            });
          },
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: seleccionado ? azul : const Color(0xFFF0F6FC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: seleccionado
                    ? azul
                    : const Color(0xFFD3E0EB),
              ),
            ),
            child: Text(
              horaCorta(horario),
              style: TextStyle(
                color: seleccionado ? Colors.white : azul,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,
      appBar: AppBar(
        backgroundColor: azul,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 52,
        title: const Text(
          'Reprogramar cita',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tu cita actual',
              style: TextStyle(
                color: azul,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            tarjetaCitaActual(),

            const SizedBox(height: 20),

            const Text(
              'Selecciona una nueva fecha',
              style: TextStyle(
                color: azul,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              height: 45,
              child: OutlinedButton.icon(
                onPressed: guardando ? null : seleccionarFecha,
                icon: const Icon(Icons.calendar_month, size: 18),
                label: Text(
                  fechaSeleccionada == null
                      ? 'Elegir fecha'
                      : formatearFecha(fechaSeleccionada!),
                  style: const TextStyle(fontSize: 12),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: azul,
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: azul, width: 1.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            if (fechaSeleccionada != null) ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Nueva fecha seleccionada',
                    style: TextStyle(
                      color: azul,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: guardando ? null : seleccionarFecha,
                    child: const Text(
                      'Cambiar',
                      style: TextStyle(
                        color: azul,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
              filaDato(
                Icons.calendar_today_outlined,
                formatearFecha(fechaSeleccionada!),
              ),
            ],

            const SizedBox(height: 20),

            const Text(
              'Horarios disponibles',
              style: TextStyle(
                color: azul,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            construirHorarios(),

            const SizedBox(height: 22),

            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton.icon(
                onPressed: guardando ||
                    horarioSeleccionado == null
                    ? null
                    : confirmarReprogramacion,
                icon: guardando
                    ? const SizedBox(
                  width: 17,
                  height: 17,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : const Icon(Icons.check_circle, size: 18),
                label: Text(
                  guardando
                      ? 'Procesando...'
                      : 'Confirmar nueva cita',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: azul,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: const Color(0xFFCBD5DF),
                  disabledForegroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------
// PANTALLA PERSONALIZADA DEL CALENDARIO
// ------------------------------------------------------

class CalendarioCitasScreen extends StatefulWidget {
  final DateTime fechaInicial;

  const CalendarioCitasScreen({
    super.key,
    required this.fechaInicial,
  });

  @override
  State<CalendarioCitasScreen> createState() =>
      _CalendarioCitasScreenState();
}

class _CalendarioCitasScreenState
    extends State<CalendarioCitasScreen> {
  late DateTime mesActual;
  DateTime? fechaTemporal;

  static const List<String> meses = [
    'Enero', 'Febrero', 'Marzo', 'Abril',
    'Mayo', 'Junio', 'Julio', 'Agosto',
    'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
  ];

  static const List<String> dias = [
    'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'
  ];

  @override
  void initState() {
    super.initState();
    mesActual = DateTime(
      widget.fechaInicial.year,
      widget.fechaInicial.month,
    );
    fechaTemporal = widget.fechaInicial;
  }

  bool esDiaValido(DateTime fecha) {
    final ahora = DateTime.now();
    final hoy = DateTime(ahora.year, ahora.month, ahora.day);

    return fecha.isAfter(hoy) &&
        fecha.weekday >= DateTime.monday &&
        fecha.weekday <= DateTime.friday;
  }

  void cambiarMes(int diferencia) {
    final nuevoMes = DateTime(
      mesActual.year,
      mesActual.month + diferencia,
    );

    final ahora = DateTime.now();
    final limite = DateTime(
      ahora.year + 1,
      ahora.month,
      ahora.day,
    );

    if (nuevoMes.isBefore(DateTime(ahora.year, ahora.month)) ||
        nuevoMes.isAfter(DateTime(limite.year, limite.month))) {
      return;
    }

    setState(() {
      mesActual = nuevoMes;
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalDias = DateUtils.getDaysInMonth(
      mesActual.year,
      mesActual.month,
    );

    final primerDia = DateTime(
      mesActual.year,
      mesActual.month,
      1,
    );

    final desplazamiento = primerDia.weekday - 1;
    final totalCeldas = ((desplazamiento + totalDias + 6) ~/ 7) * 7;

    final ahora = DateTime.now();
    final mesMinimo = DateTime(ahora.year, ahora.month);
    final mesMaximo = DateTime(ahora.year + 1, ahora.month);

    final puedeRetroceder = mesActual.isAfter(mesMinimo);
    final puedeAvanzar = mesActual.isBefore(mesMaximo);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: azul,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 48,
        title: const Text(
          'Selecciona la nueva fecha',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 18),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: puedeRetroceder
                        ? () => cambiarMes(-1)
                        : null,
                    icon: const Icon(
                      Icons.chevron_left,
                      color: azul,
                      size: 28,
                    ),
                  ),
                  Text(
                    '${meses[mesActual.month - 1]} de ${mesActual.year}',
                    style: const TextStyle(
                      color: azul,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: puedeAvanzar
                        ? () => cambiarMes(1)
                        : null,
                    icon: const Icon(
                      Icons.chevron_right,
                      color: azul,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: dias.map((dia) {
                  return Expanded(
                    child: Center(
                      child: Text(
                        dia,
                        style: const TextStyle(
                          color: textoSecundario,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: totalCeldas,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 3,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  final numeroDia = index - desplazamiento + 1;

                  if (numeroDia < 1 || numeroDia > totalDias) {
                    return const SizedBox.shrink();
                  }

                  final fecha = DateTime(
                    mesActual.year,
                    mesActual.month,
                    numeroDia,
                  );

                  final valido = esDiaValido(fecha);
                  final seleccionado = fechaTemporal != null &&
                      DateUtils.isSameDay(fecha, fechaTemporal);

                  return InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: valido
                        ? () {
                      setState(() {
                        fechaTemporal = fecha;
                      });
                    }
                        : null,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: seleccionado
                            ? azulBoton
                            : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$numeroDia',
                        style: TextStyle(
                          color: seleccionado
                              ? Colors.white
                              : valido
                              ? azul
                              : const Color(0xFFB9C8D4),
                          fontSize: 11,
                          fontWeight: seleccionado
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const Spacer(),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(
                          color: azulBoton,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: fechaTemporal == null ||
                          !esDiaValido(fechaTemporal!)
                          ? null
                          : () => Navigator.pop(
                        context,
                        fechaTemporal,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: azulBoton,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(0, 45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Continuar'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
