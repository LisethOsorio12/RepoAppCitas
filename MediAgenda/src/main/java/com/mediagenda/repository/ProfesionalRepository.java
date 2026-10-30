package com.mediagenda.repository;

import com.mediagenda.entity.Profesional;
import io.quarkus.hibernate.orm.panache.PanacheRepository;
import jakarta.enterprise.context.ApplicationScoped;

import java.util.List;

@ApplicationScoped
public class ProfesionalRepository implements PanacheRepository<Profesional> {

    public List<Profesional> listarPorEspecialidad(Long especialidadId) {

        return list(
                "especialidad.id = ?1 and activo = true and disponible = true",
                especialidadId
        );
    }
}