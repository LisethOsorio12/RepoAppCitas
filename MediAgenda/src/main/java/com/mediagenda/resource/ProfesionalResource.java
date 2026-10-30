package com.mediagenda.resource;

import com.mediagenda.entity.Profesional;
import com.mediagenda.repository.ProfesionalRepository;

import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;

import java.util.List;

@Path("/api/profesionales")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class ProfesionalResource {

    @Inject
    ProfesionalRepository repository;

    @GET
    @Path("/especialidad/{id}")
    public List<Profesional> listarPorEspecialidad(
            @PathParam("id") Long especialidadId) {

        return repository.listarPorEspecialidad(especialidadId);
    }
}