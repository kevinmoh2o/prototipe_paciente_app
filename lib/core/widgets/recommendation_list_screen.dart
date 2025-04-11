import 'package:flutter/material.dart';
import 'package:paciente_app/core/data/models/patient_model.dart';
import 'package:paciente_app/core/data/models/recommendation_model.dart';
import 'package:paciente_app/core/widgets/recommendation_detail_screen.dart';

class RecommendationListScreen extends StatelessWidget {
  final String screenTitle;
  final IconData iconData; // Ej. Icons.fitness_center, Icons.restaurant...
  final Color iconBgColor; // Ej. Colors.green.shade50
  final Color iconColor; // Ej. Colors.green
  final List<RecommendationModel> allRecommendations;

  /// Paciente para filtrar. Si se deja null, se muestran todas.
  final PatientModel? patient;

  const RecommendationListScreen({
    Key? key,
    required this.screenTitle,
    required this.iconData,
    required this.iconBgColor,
    required this.iconColor,
    required this.allRecommendations,
    this.patient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ────────── Filtra según diagnóstico, si patient != null
    final filteredRecommendations = _filterByDiagnosis(allRecommendations, patient);

    return Scaffold(
      appBar: AppBar(
        title: Text(screenTitle),
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredRecommendations.length,
        itemBuilder: (ctx, i) {
          final recommendation = filteredRecommendations[i];

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
            child: Row(
              children: [
                // Ícono a la izquierda
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(iconData, color: iconColor),
                ),
                const SizedBox(width: 12),

                // Título + breve descripción
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recommendation.title,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        recommendation.shortDescription,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),

                // Botón "Ver" que abre el detalle
                ElevatedButton(
                  onPressed: () {
                    // Navega a la pantalla de detalle
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => RecommendationDetailScreen(recommendation: recommendation),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  child: const Text("Ver", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Filtra las recomendaciones si targetDiagnoses no está vacío
  /// y el diagnostico del paciente no coincide.
  List<RecommendationModel> _filterByDiagnosis(
    List<RecommendationModel> list,
    PatientModel? patient,
  ) {
    if (patient == null || patient.diagnostico == null) {
      return list; // Sin paciente o sin diagnóstico => no filtrar
    }

    final diag = patient.diagnostico!.toLowerCase().trim();
    return list.where((item) {
      if (item.targetDiagnoses.isEmpty) return true;
      // Si la lista no está vacía, chequea si el diag del paciente coincide
      return item.targetDiagnoses.map((d) => d.toLowerCase().trim()).contains(diag);
    }).toList();
  }
}
