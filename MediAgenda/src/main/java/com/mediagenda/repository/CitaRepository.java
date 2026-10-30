
package com.mediagenda.repository;

import com.mediagenda.entity.Cita;
import io.quarkus.hibernate.orm.panache.PanacheRepository;
import jakarta.enterprise.context.ApplicationScoped;
import java.time.LocalDateTime;
import java.util.List;

@ApplicationScoped
public class CitaRepository implements PanacheRepository<Cita> {

    // Consultar las citas futuras y vigentes de un paciente
    public List<Cita> listarCitasFuturas(Long pacienteId) {
        return list(
                "pacienteId = ?1 and estado = ?2 and fechaHora > ?3 order by fechaHora",
                pacienteId,
                "VIGENTE",
                LocalDateTime.now()
        );
    }

    // Buscar una cita perteneciente a un paciente
    public Cita buscarPorPaciente(Long citaId, Long pacienteId) {
        return find(
                "id = ?1 and pacienteId = ?2",
                citaId,
                pacienteId
        ).firstResult();
    }

    // Verificar si un profesional tiene una cita vigente
    // en el horario seleccionado
    public boolean existeCitaEnHorario(
            Long profesionalId,
            LocalDateTime fechaHora,
            Long citaExcluirId) {

        return count(
                "profesional.id = ?1 and fechaHora = ?2 " +
                        "and estado = ?3 and id != ?4",
                profesionalId,
                fechaHora,
                "VIGENTE",
                citaExcluirId
        ) > 0;
    }
}
