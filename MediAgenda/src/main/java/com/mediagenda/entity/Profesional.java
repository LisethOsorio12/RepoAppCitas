package com.mediagenda.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;

@Entity
@Table(name = "profesionales")
public class Profesional {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    public Long id;

    @Column(nullable = false)
    public String nombre;

    @Column(nullable = false)
    public String informacionProfesional;

    @Column(nullable = false)
    public boolean activo;

    @Column(nullable = false)
    public boolean disponible;

    @ManyToOne
    @JoinColumn(name = "especialidad_id", nullable = false)
    @JsonIgnore
    public Especialidad especialidad;

    public Profesional() {
    }

    public Profesional(
            String nombre,
            String informacionProfesional,
            boolean activo,
            boolean disponible,
            Especialidad especialidad) {

        this.nombre = nombre;
        this.informacionProfesional = informacionProfesional;
        this.activo = activo;
        this.disponible = disponible;
        this.especialidad = especialidad;
    }
}