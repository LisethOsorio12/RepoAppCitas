
package com.mediagenda.dto;

import com.mediagenda.entity.Cita;
import java.time.LocalDateTime;

public class CitaResponse {

    public Long id;
    public Long pacienteId;
    public Long profesionalId;
    public String profesionalNombre;
    public String especialidadNombre;
    public LocalDateTime fechaHora;
    public String estado;

    public CitaResponse() {
    }

    public CitaResponse(Cita cita) {
        this.id = cita.id;
        this.pacienteId = cita.pacienteId;
        this.profesionalId = cita.profesional.id;
        this.profesionalNombre = cita.profesional.nombre;
        this.especialidadNombre =
                cita.profesional.especialidad != null
                        ? cita.profesional.especialidad.nombre
                        : null;
        this.fechaHora = cita.fechaHora;
        this.estado = cita.estado;
    }

    public Long getId() {
        return id;
    }

    public Long getPacienteId() {
        return pacienteId;
    }

    public Long getProfesionalId() {
        return profesionalId;
    }

    public String getProfesionalNombre() {
        return profesionalNombre;
    }

    public String getEspecialidadNombre() {
        return especialidadNombre;
    }

    public LocalDateTime getFechaHora() {
        return fechaHora;
    }

    public String getEstado() {
        return estado;
    }
}
