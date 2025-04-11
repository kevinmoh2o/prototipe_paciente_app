// lib/features/psicologico_espiritual/presentation/screen/apoyo_espiritual_screen.dart

import 'package:flutter/material.dart';
import 'package:paciente_app/core/data/models/patient_model.dart';
import 'package:paciente_app/core/data/models/recommendation_model.dart';
import 'package:paciente_app/core/widgets/recommendation_list_screen.dart';
import 'package:provider/provider.dart';
import 'package:paciente_app/features/psicologico_espiritual/presentation/provider/psicologia_provider.dart';

class ApoyoEspiritualScreen extends StatelessWidget {
  const ApoyoEspiritualScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final psyProv = context.watch<PsicologiaProvider>();

    final PatientModel? paciente = /* recupera tu paciente con SharedPrefs o Provider */ null;

    // Suponiendo que definiste en algún lado:
    final List<RecommendationModel> miListaDeRutinas = psyProv.recursosEspiritualesRecommendations;

    return RecommendationListScreen(
      screenTitle: "Apoyo Espiritual",
      iconData: Icons.self_improvement,
      iconBgColor: Colors.green.shade50,
      iconColor: Colors.green,
      allRecommendations: miListaDeRutinas,
      patient: paciente, // para filtrar por diagnóstico
    );

    /* return Scaffold(
      appBar: AppBar(
        title: const Text("Apoyo Espiritual"),
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: recursos.length,
        itemBuilder: (ctx, i) {
          final res = recursos[i];
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
                )
              ],
            ),
            child: Text(
              res,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          );
        },
      ),
    ); */
  }
}
