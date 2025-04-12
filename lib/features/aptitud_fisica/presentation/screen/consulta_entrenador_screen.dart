import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'package:paciente_app/features/aptitud_fisica/presentation/provider/aptitud_provider.dart';
import 'package:paciente_app/features/menu_calendar/presentation/provider/calendar_provider.dart';
import 'package:paciente_app/features/menu_calendar/presentation/screen/calendar_screen.dart';

import 'package:paciente_app/core/data/models/doctor_model.dart';

class ConsultaEntrenadorScreen extends StatelessWidget {
  const ConsultaEntrenadorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final aptProv = context.watch<AptitudProvider>();
    final entrenadores = aptProv.entrenadores;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Consulta con Entrenador"),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: entrenadores.length,
        itemBuilder: (ctx, i) {
          final ent = entrenadores[i];

          // Convertimos el EntrenadorInfo en un "DoctorModel"
          final forcedDoctor = DoctorModel(
            id: "ent_${ent.name}",
            name: ent.name,
            specialty: "Entrenador Físico",
            profileImage: ent.imageAsset,
            rating: ent.rating,
            reviewsCount: 15,
            consultationFee: 40.0, // Ajusta a tu gusto
          );

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(ent.imageAsset),
                  radius: 30,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ent.name,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 16, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text("${ent.rating}★"),
                          const SizedBox(width: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: ent.isOnline ? Colors.green : Colors.grey,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            child: Text(
                              ent.isOnline ? "Online" : "Offline",
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // BOTÓN para ir a CalendarWizard con skip
                IconButton(
                  icon: const Icon(Icons.schedule, color: Colors.blue),
                  onPressed: () {
                    final cp = context.read<CalendarProvider>();
                    // Start wizard for “Aptitud Fisica” => skip cat/doct
                    cp.startScheduling(
                      forcedCategory: null, // O creas un AppointmentCategory.aptitud si gustas
                      forcedDoctor: forcedDoctor,
                      skipCategoryStep: true,
                      skipDoctorStep: true,
                    );
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const CalendarScreen(isarrowBackActive: true),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(FontAwesomeIcons.whatsapp, color: Colors.green),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("WhatsApp a ${ent.name} (demo)...")),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
