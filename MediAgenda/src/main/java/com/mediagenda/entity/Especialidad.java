package com.mediagenda.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "especialidades")
public class Especialidad {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    public Long id;

    @Column(nullable = false, unique = true)
    public String nombre;

    @Column(nullable = false)
    public String descripcion;

    @Column(nullable = false)
    public boolean activa;

    public Especialidad() {
    }

    public Especialidad(
            String nombre,
            String descripcion,
            boolean activa) {

        this.nombre = nombre;
        this.descripcion = descripcion;
        this.activa = activa;
    }
}