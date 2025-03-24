import 'package:flutter/material.dart';
import 'package:paciente_app/features/menu_calendar/presentation/provider/calendar_provider.dart';

class AppointmentListTile extends StatelessWidget {
  final AppointmentModel appointment;
  const AppointmentListTile({Key? key, required this.appointment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeString = _formatHour(appointment.dateTime);

    return Container(
      decoration: BoxDecoration(
        color: Colors.purple[50],
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(appointment.doctor.profileImage),
            radius: 24,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appointment.doctor.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Text(
                  appointment.doctor.specialty,
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
                // Horario
                const SizedBox(height: 4),
                Text(
                  "$timeString - ${_addMinutes(timeString, 45)}",
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
          // Si es telemedicina, mostramos el ícono de videollamada
          if (appointment.isTelemedicine)
            Container(
              decoration: BoxDecoration(
                color: Colors.white70,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.video_call, color: Colors.purple),
                onPressed: () {
                  // Iniciar videollamada
                },
              ),
            ),
        ],
      ),
    );
  }

  // Formatear hora en "8:30 a.m."
  String _formatHour(DateTime dt) {
    final hour = dt.hour;
    final minute = dt.minute.toString().padLeft(2, '0');
    final ampm = (hour >= 12) ? "p.m." : "a.m.";
    final h12 = hour % 12 == 0 ? 12 : hour % 12;
    return "$h12:$minute $ampm";
  }

  // Sumar 45 min como ejemplo
  String _addMinutes(String time, int addMins) {
    // Super simplificado: "8:30 a.m." -> parse
    final parts = time.split(" ");
    if (parts.length != 2) return time;
    final meridiem = parts[1];
    final hourMin = parts[0].split(":"); // 8 y 30

    int h = int.tryParse(hourMin[0]) ?? 0;
    int m = int.tryParse(hourMin[1]) ?? 0;
    m += addMins;
    while (m >= 60) {
      m -= 60;
      h += 1;
    }
    // Manejo AM/PM
    // ...
    // Para simplificar, no cambio AM/PM, etc. (en un caso real, parseo robusto).
    return "$h:${m.toString().padLeft(2, '0')} $meridiem";
  }
}
