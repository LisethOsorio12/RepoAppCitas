
package com.mediagenda.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(
        name = "citas",
        uniqueConstraints = {
                @UniqueConstraint(
                        name = "uk_cita_profesional_fecha",
                        columnNames = {"profesional_id", "fecha_hora"}
                )
        }
)
public class Cita {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    public Long id;

    @Column(name = "paciente_id", nullable = false)
    public Long pacienteId;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "profesional_id", nullable = false)
    public Profesional profesional;

    @Column(name = "fecha_hora", nullable = false)
    public LocalDateTime fechaHora;

    @Column(nullable = false)
    public String estado;

    public Cita() {
    }

    public Cita(
            Long pacienteId,
            Profesional profesional,
            LocalDateTime fechaHora,
            String estado) {

        this.pacienteId = pacienteId;
        this.profesional = profesional;
        this.fechaHora = fechaHora;
        this.estado = estado;
    }
}
