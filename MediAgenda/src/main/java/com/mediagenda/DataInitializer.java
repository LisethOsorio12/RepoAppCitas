package com.mediagenda;

import com.mediagenda.entity.Especialidad;
import com.mediagenda.entity.Profesional;
import com.mediagenda.repository.EspecialidadRepository;
import com.mediagenda.repository.ProfesionalRepository;
import io.quarkus.runtime.Startup;
import io.quarkus.runtime.StartupEvent;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.enterprise.event.Observes;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;

@Startup
@ApplicationScoped
public class DataInitializer {

    @Inject
    EspecialidadRepository especialidadRepository;

    @Inject
    ProfesionalRepository profesionalRepository;

    @Transactional
    void init(@Observes StartupEvent event) {

        // ==========================================
        // CREAR ESPECIALIDADES
        // ==========================================

        if (especialidadRepository.count() == 0) {

            Especialidad cardiologia = new Especialidad(
                    "Cardiología",
                    "Especialidad médica relacionada con el corazón.",
                    true
            );

            Especialidad dermatologia = new Especialidad(
                    "Dermatología",
                    "Especialidad médica relacionada con la piel.",
                    true
            );

            Especialidad pediatria = new Especialidad(
                    "Pediatría",
                    "Atención médica especializada para niños.",
                    true
            );

            Especialidad medicinaGeneral = new Especialidad(
                    "Medicina General",
                    "Atención médica integral y preventiva.",
                    true
            );

            especialidadRepository.persist(cardiologia);
            especialidadRepository.persist(dermatologia);
            especialidadRepository.persist(pediatria);
            especialidadRepository.persist(medicinaGeneral);
        }

        // ==========================================
        // BUSCAR ESPECIALIDADES
        // ==========================================

        Especialidad cardiologia =
                especialidadRepository.find("nombre", "Cardiología")
                        .firstResult();

        Especialidad dermatologia =
                especialidadRepository.find("nombre", "Dermatología")
                        .firstResult();

        Especialidad pediatria =
                especialidadRepository.find("nombre", "Pediatría")
                        .firstResult();

        Especialidad medicinaGeneral =
                especialidadRepository.find("nombre", "Medicina General")
                        .firstResult();

        // ==========================================
        // CREAR PROFESIONALES
        // ==========================================

        if (profesionalRepository.count() == 0) {

            profesionalRepository.persist(
                    new Profesional(
                            "Dra. Laura Martínez",
                            "Médica especialista en cardiología.",
                            true,
                            true,
                            cardiologia
                    )
            );

            profesionalRepository.persist(
                    new Profesional(
                            "Dr. Carlos Rodríguez",
                            "Médico especialista en cardiología clínica.",
                            true,
                            true,
                            cardiologia
                    )
            );

            profesionalRepository.persist(
                    new Profesional(
                            "Dra. Ana Gómez",
                            "Médica especialista en dermatología.",
                            true,
                            true,
                            dermatologia
                    )
            );

            profesionalRepository.persist(
                    new Profesional(
                            "Dr. Juan Pérez",
                            "Médico especialista en pediatría.",
                            true,
                            true,
                            pediatria
                    )
            );

            profesionalRepository.persist(
                    new Profesional(
                            "Dra. María López",
                            "Médica de atención general.",
                            true,
                            true,
                            medicinaGeneral
                    )
            );
        }
    }
}