import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:paciente_app/core/data/models/patient_model.dart';
import 'package:paciente_app/core/data/models/recommendation_model.dart';
import 'package:paciente_app/core/widgets/recommendation_list_screen.dart';
import 'package:paciente_app/features/aptitud_fisica/presentation/provider/aptitud_provider.dart';

class RutinasScreen extends StatelessWidget {
  const RutinasScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final aptProv = context.watch<AptitudProvider>();
    final PatientModel? paciente = /* recupera tu paciente con SharedPrefs o Provider */ null;

    // Suponiendo que definiste en algún lado:
    final List<RecommendationModel> miListaDeRutinas = aptProv.miListaDeRutinas;

    return RecommendationListScreen(
      screenTitle: "Rutinas Recomendadas",
      iconData: Icons.fitness_center,
      iconBgColor: Colors.green.shade50,
      iconColor: Colors.green,
      allRecommendations: miListaDeRutinas,
      patient: paciente, // para filtrar por diagnóstico
    );
  }
}
