
package com.mediagenda;

import com.mediagenda.entity.Especialidad;
import com.mediagenda.entity.Profesional;
import com.mediagenda.entity.Cita;

import com.mediagenda.repository.EspecialidadRepository;
import com.mediagenda.repository.ProfesionalRepository;
import com.mediagenda.repository.CitaRepository;

import io.quarkus.runtime.Startup;
import io.quarkus.runtime.StartupEvent;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.enterprise.event.Observes;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.DayOfWeek;

@Startup
@ApplicationScoped
public class DataInitializer {

    @Inject
    EspecialidadRepository especialidadRepository;

    @Inject
    ProfesionalRepository profesionalRepository;

    @Inject
    CitaRepository citaRepository;

    @Transactional
    void init(@Observes StartupEvent event) {

        // ==========================================
        // 1. CREAR ESPECIALIDADES
        // ==========================================

        crearEspecialidad(
                "Cardiología",
                "Especialidad médica relacionada con el corazón."
        );

        crearEspecialidad(
                "Dermatología",
                "Especialidad médica relacionada con la piel."
        );

        crearEspecialidad(
                "Pediatría",
                "Atención médica especializada para niños."
        );

        crearEspecialidad(
                "Medicina General",
                "Atención médica integral y preventiva."
        );

        // ==========================================
        // 2. BUSCAR ESPECIALIDADES
        // ==========================================

        Especialidad cardiologia =
                especialidadRepository.find(
                        "nombre", "Cardiología"
                ).firstResult();

        Especialidad dermatologia =
                especialidadRepository.find(
                        "nombre", "Dermatología"
                ).firstResult();

        Especialidad pediatria =
                especialidadRepository.find(
                        "nombre", "Pediatría"
                ).firstResult();

        Especialidad medicinaGeneral =
                especialidadRepository.find(
                        "nombre", "Medicina General"
                ).firstResult();

        // ==========================================
        // 3. CREAR PROFESIONALES
        // ==========================================

        crearProfesional(
                "Dra. Laura Martínez",
                "Especialista en enfermedades cardiovasculares.",
                cardiologia
        );

        crearProfesional(
                "Dr. Carlos Rodríguez",
                "Especialista en cuidado y salud de la piel.",
                dermatologia
        );

        crearProfesional(
                "Dra. Ana Gómez",
                "Especialista en atención médica infantil.",
                pediatria
        );

        crearProfesional(
                "Dr. Juan Pérez",
                "Médico especialista en atención primaria.",
                medicinaGeneral
        );

        crearProfesional(
                "Dra. María López",
                "Médica especialista en atención general y preventiva.",
                medicinaGeneral
        );

        // ==========================================
        // 4. CREAR UNA CITA PARA CADA PROFESIONAL
        // ==========================================

        for (Profesional profesional :
                profesionalRepository.listAll()) {

            // Verificar si el paciente ya tiene una cita
            // con este profesional.
            long citasExistentes = citaRepository.count(
                    "pacienteId = ?1 and profesional.id = ?2",
                    1L,
                    profesional.id
            );

            // No duplicar citas existentes.
            if (citasExistentes == 0) {

                // Buscar una fecha futura en día hábil.
                LocalDate fecha = LocalDate.now().plusDays(7);

                while (
                        fecha.getDayOfWeek() == DayOfWeek.SATURDAY ||
                                fecha.getDayOfWeek() == DayOfWeek.SUNDAY
                ) {
                    fecha = fecha.plusDays(1);
                }

                // Crear cita a las 9:00 a. m.
                LocalDateTime fechaHora =
                        fecha.atTime(9, 0);

                Cita cita = new Cita(
                        1L,
                        profesional,
                        fechaHora,
                        "VIGENTE"
                );

                citaRepository.persist(cita);
            }
        }
    }

    // ==========================================
    // MÉTODO PARA CREAR ESPECIALIDADES
    // ==========================================

    private void crearEspecialidad(
            String nombre,
            String descripcion) {

        long existentes = especialidadRepository.count(
                "nombre", nombre
        );

        if (existentes == 0) {

            Especialidad especialidad = new Especialidad();

            especialidad.nombre = nombre;
            especialidad.descripcion = descripcion;
            especialidad.activa = true;

            especialidadRepository.persist(especialidad);
        }
    }

    // ==========================================
    // MÉTODO PARA CREAR PROFESIONALES
    // ==========================================

    private void crearProfesional(
            String nombre,
            String informacion,
            Especialidad especialidad) {

        if (especialidad == null) {
            return;
        }

        long existentes = profesionalRepository.count(
                "nombre", nombre
        );

        if (existentes == 0) {

            Profesional profesional = new Profesional();

            profesional.nombre = nombre;
            profesional.informacionProfesional = informacion;
            profesional.activo = true;
            profesional.disponible = true;
            profesional.especialidad = especialidad;

            profesionalRepository.persist(profesional);
        }
    }
}
