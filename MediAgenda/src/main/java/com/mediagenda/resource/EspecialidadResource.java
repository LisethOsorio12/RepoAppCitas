package com.mediagenda.resource;

import com.mediagenda.entity.Especialidad;
import com.mediagenda.repository.EspecialidadRepository;
import jakarta.inject.Inject;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;

import java.util.List;

@Path("/api/especialidades")
@Produces(MediaType.APPLICATION_JSON)
public class EspecialidadResource {

    @Inject
    EspecialidadRepository repository;

    @GET
    public List<Especialidad> listarEspecialidades() {
        return repository.listarActivas();
    }
}