package com.mediagenda.repository;

import com.mediagenda.entity.Especialidad;
import io.quarkus.hibernate.orm.panache.PanacheRepository;
import jakarta.enterprise.context.ApplicationScoped;

import java.util.List;

@ApplicationScoped
public class EspecialidadRepository implements PanacheRepository<Especialidad> {

    public List<Especialidad> listarActivas() {
        return list("activa", true);
    }
}