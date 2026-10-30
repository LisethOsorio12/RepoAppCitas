
package com.mediagenda.dto;

import java.time.LocalDateTime;

public class ReprogramacionRequest {

    public Long pacienteId;

    public LocalDateTime nuevaFechaHora;

    public ReprogramacionRequest() {
    }

    public ReprogramacionRequest(
            Long pacienteId,
            LocalDateTime nuevaFechaHora) {

        this.pacienteId = pacienteId;
        this.nuevaFechaHora = nuevaFechaHora;
    }

    public Long getPacienteId() {
        return pacienteId;
    }

    public void setPacienteId(Long pacienteId) {
        this.pacienteId = pacienteId;
    }

    public LocalDateTime getNuevaFechaHora() {
        return nuevaFechaHora;
    }

    public void setNuevaFechaHora(LocalDateTime nuevaFechaHora) {
        this.nuevaFechaHora = nuevaFechaHora;
    }
}
