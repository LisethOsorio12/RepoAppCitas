
package com.mediagenda.resource;

import com.mediagenda.dto.CitaResponse;
import com.mediagenda.dto.ReprogramacionRequest;
import com.mediagenda.entity.Cita;
import com.mediagenda.repository.CitaRepository;
import com.mediagenda.service.CitaService;
import com.mediagenda.service.DisponibilidadService;

import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Path("/api/citas")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class CitaResource {

    @Inject
    CitaRepository citaRepository;

    @Inject
    CitaService citaService;

    @Inject
    DisponibilidadService disponibilidadService;

    /**
     * Consulta las citas futuras y vigentes de un paciente.
     *
     * GET /api/citas/paciente/1
     */
    @GET
    @Path("/paciente/{pacienteId}")
    public List<CitaResponse> listarCitasPaciente(
            @PathParam("pacienteId") Long pacienteId) {

        return citaRepository.listarCitasFuturas(pacienteId)
                .stream()
                .map(CitaResponse::new)
                .toList();
    }

    /**
     * Consulta los horarios disponibles para reprogramar
     * una cita, conservando el mismo profesional.
     *
     * GET /api/citas/1/horarios-disponibles
     * ?pacienteId=1&fecha=2026-11-06
     */
    @GET
    @Path("/{citaId}/horarios-disponibles")
    public List<LocalDateTime> consultarHorariosDisponibles(
            @PathParam("citaId") Long citaId,
            @QueryParam("pacienteId") Long pacienteId,
            @QueryParam("fecha") String fecha) {

        if (pacienteId == null ||
                fecha == null ||
                fecha.isBlank()) {

            throw new BadRequestException(
                    "Debes proporcionar el paciente y la fecha."
            );
        }

        LocalDate fechaSeleccionada;

        try {
            fechaSeleccionada = LocalDate.parse(fecha);
        } catch (Exception e) {
            throw new BadRequestException(
                    "La fecha debe tener el formato AAAA-MM-DD."
            );
        }

        // Verificar que la cita pertenezca al paciente.
        Cita cita = citaService.consultarCitaPaciente(
                citaId,
                pacienteId
        );

        // Consultar disponibilidad del mismo profesional.
        List<LocalDateTime> horarios =
                disponibilidadService.consultarHorariosDisponibles(
                        cita.profesional.id,
                        fechaSeleccionada,
                        cita.id
                );

        // Excluir el horario que actualmente ocupa esta cita.
        // Así no se muestra como disponible.
        return horarios.stream()
                .filter(horario -> !horario.equals(cita.fechaHora))
                .toList();
    }

    /**
     * Reprograma una cita vigente.
     *
     * PUT /api/citas/1/reprogramar
     */
    @PUT
    @Path("/{citaId}/reprogramar")
    public CitaResponse reprogramarCita(
            @PathParam("citaId") Long citaId,
            ReprogramacionRequest request) {

        if (request == null ||
                request.pacienteId == null ||
                request.nuevaFechaHora == null) {

            throw new BadRequestException(
                    "Debes proporcionar el paciente, la nueva fecha y la hora."
            );
        }

        Cita citaActualizada = citaService.reprogramarCita(
                citaId,
                request.pacienteId,
                request.nuevaFechaHora
        );

        return new CitaResponse(citaActualizada);
    }
}
