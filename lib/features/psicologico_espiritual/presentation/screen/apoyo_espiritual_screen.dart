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
      categoryTitle: "Apoyo Psicológico Espiritual",
    );
  }
}
