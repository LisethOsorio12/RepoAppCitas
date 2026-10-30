
package com.mediagenda.service;

import com.mediagenda.repository.CitaRepository;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

@ApplicationScoped
public class DisponibilidadService {

    @Inject
    CitaRepository citaRepository;

    public List<LocalDateTime> consultarHorariosDisponibles(
            Long profesionalId,
            LocalDate fecha,
            Long citaExcluirId) {

        List<LocalDateTime> horarios = new ArrayList<>();

        // No permitir fechas pasadas ni el día actual
        if (!fecha.isAfter(LocalDate.now())) {
            return horarios;
        }

        // Atención únicamente de lunes a viernes
        DayOfWeek dia = fecha.getDayOfWeek();

        if (dia == DayOfWeek.SATURDAY ||
                dia == DayOfWeek.SUNDAY) {
            return horarios;
        }

        // Generar horarios desde las 8:00 hasta las 16:00
        for (int hora = 8; hora < 17; hora++) {

            LocalDateTime fechaHora = LocalDateTime.of(
                    fecha,
                    LocalTime.of(hora, 0)
            );

            // Comprobar que el horario no haya pasado
            if (!fechaHora.isAfter(LocalDateTime.now())) {
                continue;
            }

            // Verificar si ya existe otra cita en ese horario
            boolean ocupado = citaRepository
                    .existeCitaEnHorario(
                            profesionalId,
                            fechaHora,
                            citaExcluirId
                    );

            if (!ocupado) {
                horarios.add(fechaHora);
            }
        }

        return horarios;
    }
}
