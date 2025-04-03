import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:paciente_app/core/data/services/telemedicina_service.dart';
import 'package:paciente_app/features/telemedicina/presentation/screen/chat_screen.dart';
import 'package:paciente_app/features/telemedicina/presentation/screen/video_call_screen.dart';

class TelemedicinaDoctorsList extends StatelessWidget {
  final List<TelemedDoctor> doctors;

  const TelemedicinaDoctorsList({Key? key, required this.doctors}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (doctors.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 32),
        child: Text(
          "No hay doctores con los filtros seleccionados.",
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return Column(
      children: doctors.map((doc) => _DoctorCard(doctor: doc)).toList(),
    );
  }
}

class _DoctorCard extends StatelessWidget {
  final TelemedDoctor doctor;
  const _DoctorCard({Key? key, required this.doctor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          // Avatar del doctor
          CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage(doctor.profileImage),
          ),
          const SizedBox(width: 12),

          // Info del doctor
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  doctor.specialty,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text("${doctor.rating.toStringAsFixed(1)}★"),
                  ],
                ),
              ],
            ),
          ),

          // Dos botones circulares: videollamada y WhatsApp
          Row(
            children: [
              // 1) Videollamada
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
                          doctorName: doctor.name,
                          doctorSpecialty: doctor.specialty,
                          doctorImage: doctor.profileImage,
                        ),
                      ),
                    );
                  },
                ),
              ),

              // 2) WhatsApp
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
                          doctorName: doctor.name,
                          doctorImage: doctor.profileImage,
                          lastSeen: "5 minutos",
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
