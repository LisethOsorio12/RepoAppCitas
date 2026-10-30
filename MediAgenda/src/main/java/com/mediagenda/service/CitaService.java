
package com.mediagenda.service;

import com.mediagenda.entity.Cita;
import com.mediagenda.repository.CitaRepository;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.BadRequestException;
import jakarta.ws.rs.NotFoundException;
import jakarta.ws.rs.WebApplicationException;
import jakarta.ws.rs.core.Response;

import java.time.LocalDateTime;

@ApplicationScoped
public class CitaService {

    @Inject
    CitaRepository citaRepository;

    @Inject
    DisponibilidadService disponibilidadService;

    /**
     * Consulta una cita perteneciente a un paciente.
     */
    public Cita consultarCitaPaciente(Long citaId, Long pacienteId) {

        Cita cita = citaRepository.buscarPorPaciente(citaId, pacienteId);

        if (cita == null) {
            throw new NotFoundException(
                    "No se encontró la cita para este paciente."
            );
        }

        return cita;
    }

    /**
     * Reprograma una cita vigente conservando el mismo profesional.
     */
    @Transactional
    public Cita reprogramarCita(
            Long citaId,
            Long pacienteId,
            LocalDateTime nuevaFechaHora) {

        // 1. Verificar que la cita exista y pertenezca al paciente.
        Cita cita = citaRepository.buscarPorPaciente(citaId, pacienteId);

        if (cita == null) {
            throw new NotFoundException(
                    "La cita no existe o no pertenece al paciente."
            );
        }

        // 2. Verificar que la cita esté vigente.
        if (!"VIGENTE".equals(cita.estado)) {
            throw new BadRequestException(
                    "Solo se pueden reprogramar citas vigentes."
            );
        }

        // 3. Verificar que la cita original sea futura.
        if (cita.fechaHora == null ||
                !cita.fechaHora.isAfter(LocalDateTime.now())) {

            throw new BadRequestException(
                    "No se pueden reprogramar citas pasadas."
            );
        }

        // 4. Validar que la nueva fecha y hora sean futuras.
        if (nuevaFechaHora == null ||
                !nuevaFechaHora.isAfter(LocalDateTime.now())) {

            throw new BadRequestException(
                    "La nueva fecha y hora deben ser futuras."
            );
        }

        // 5. Validar días y horarios de atención.
        if (nuevaFechaHora.getDayOfWeek().getValue() > 5 ||
                nuevaFechaHora.getHour() < 8 ||
                nuevaFechaHora.getHour() >= 17 ||
                nuevaFechaHora.getMinute() != 0 ||
                nuevaFechaHora.getSecond() != 0 ||
                nuevaFechaHora.getNano() != 0) {

            throw new BadRequestException(
                    "El horario seleccionado no corresponde al horario de atención. " +
                            "La atención es de lunes a viernes, de 8:00 a. m. a 5:00 p. m."
            );
        }

        // 6. Evitar que el paciente seleccione el mismo horario.
        if (nuevaFechaHora.equals(cita.fechaHora)) {
            throw new BadRequestException(
                    "Debes seleccionar una fecha y hora diferentes a las actuales."
            );
        }

        // 7. Verificar que el horario no esté ocupado por otra cita vigente.
        boolean horarioOcupado =
                citaRepository.existeCitaEnHorario(
                        cita.profesional.id,
                        nuevaFechaHora,
                        cita.id
                );

        if (horarioOcupado) {
            throw new WebApplicationException(
                    "El horario seleccionado ya no está disponible.",
                    Response.Status.CONFLICT
            );
        }

        // 8. Consultar nuevamente la disponibilidad del profesional.
        boolean horarioDisponible =
                disponibilidadService
                        .consultarHorariosDisponibles(
                                cita.profesional.id,
                                nuevaFechaHora.toLocalDate(),
                                cita.id
                        )
                        .stream()
                        .anyMatch(horario -> horario.equals(nuevaFechaHora));

        if (!horarioDisponible) {
            throw new WebApplicationException(
                    "El horario seleccionado no está disponible.",
                    Response.Status.CONFLICT
            );
        }

        // 9. Actualizar la fecha y hora de la cita existente.
        // Se conserva el mismo ID, paciente, profesional y estado.
        cita.fechaHora = nuevaFechaHora;

        return cita;
    }
}
