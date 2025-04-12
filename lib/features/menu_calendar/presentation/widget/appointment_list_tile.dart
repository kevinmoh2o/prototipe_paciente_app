import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:paciente_app/features/menu_calendar/presentation/provider/calendar_provider.dart';
import 'package:paciente_app/features/telemedicina/presentation/screen/chat_screen.dart';
import 'package:paciente_app/features/telemedicina/presentation/screen/video_call_screen.dart';

class AppointmentListTile extends StatelessWidget {
  final AppointmentModel appointment;
  const AppointmentListTile({Key? key, required this.appointment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPaid = appointment.isPaid;
    final timeString = _formatHour(appointment.dateTime);

    return Container(
      decoration: BoxDecoration(
        color: isPaid ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
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
                    const SizedBox(height: 4),
                    // Rango de hora
                    Text("$timeString - ${_addMinutes(timeString, 45)}", style: const TextStyle(fontSize: 13)),

                    const SizedBox(height: 4),

                    // Estado de la cita
                    if (!isPaid)
                      const Text(
                        "Pendiente de Pago",
                        style: TextStyle(fontSize: 13, color: Colors.red),
                      )
                    else
                      const Text(
                        "Cita Pagada",
                        style: TextStyle(fontSize: 13, color: Colors.green),
                      ),
                  ],
                ),
              ),

              // Muestra íconos solo si está pagada
              if (isPaid) ...[
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  decoration: const BoxDecoration(
                    color: Color(0xFF5B6BF5),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const FaIcon(FontAwesomeIcons.video, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => VideoCallScreen(
                            doctorName: appointment.doctor.name,
                            doctorSpecialty: appointment.doctor.specialty,
                            doctorImage: appointment.doctor.profileImage,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const FaIcon(FontAwesomeIcons.whatsapp, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatScreen(
                            doctorName: appointment.doctor.name,
                            doctorImage: appointment.doctor.profileImage,
                            lastSeen: "5 minutos",
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
          // Rating, etc. (opcional)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 5),
            child: Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 14),
                const SizedBox(width: 4),
                Text(
                  "${appointment.doctor.rating} (${appointment.doctor.reviewsCount} Reviews)",
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatHour(DateTime dt) {
    final hour = dt.hour;
    final minute = dt.minute.toString().padLeft(2, '0');
    final ampm = (hour >= 12) ? "p.m." : "a.m.";
    final h12 = (hour % 12 == 0) ? 12 : hour % 12;
    return "$h12:$minute $ampm";
  }

  String _addMinutes(String time, int addMins) {
    final parts = time.split(" ");
    if (parts.length != 2) return time;
    final meridiem = parts[1];
    final hm = parts[0].split(":");
    int h = int.tryParse(hm[0]) ?? 0;
    int m = int.tryParse(hm[1]) ?? 0;

    m += addMins;
    while (m >= 60) {
      m -= 60;
      h += 1;
    }
    return "$h:${m.toString().padLeft(2, '0')} $meridiem";
  }
}
