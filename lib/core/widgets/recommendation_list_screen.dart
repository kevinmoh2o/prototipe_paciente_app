// lib/core/widgets/recommendation_list_screen.dart
import 'package:flutter/material.dart';
import 'package:paciente_app/core/data/services/plan_helper.dart';
import 'package:provider/provider.dart';

import 'package:paciente_app/core/data/models/patient_model.dart';
import 'package:paciente_app/core/data/models/recommendation_model.dart';
import 'package:paciente_app/core/widgets/recommendation_detail_screen.dart';

import 'package:paciente_app/core/widgets/dialogs/upgrade_dialog.dart';
import 'package:paciente_app/features/create_account/presentation/provider/patient_provider.dart';

class RecommendationListScreen extends StatelessWidget {
  final String screenTitle;
  final String categoryTitle; // ⬅️ nuevo: categoría real para PlanHelper
  final IconData iconData;
  final Color iconBgColor;
  final Color iconColor;
  final List<RecommendationModel> allRecommendations;
  final PatientModel? patient;

  const RecommendationListScreen({
    Key? key,
    required this.screenTitle,
    required this.categoryTitle,
    required this.iconData,
    required this.iconBgColor,
    required this.iconColor,
    required this.allRecommendations,
    this.patient,
  }) : super(key: key);

  void _promptUpgrade(BuildContext ctx) {
    DialogHelper.showUpgradeDialog(
      context: ctx,
      categoryTitle: categoryTitle,
      description: 'Elige el plan que mejor se adapte a ti para continuar con tu proceso:',
    );
  }

  @override
  Widget build(BuildContext context) {
    // filtra por diagnóstico si se pasa paciente
    final filtered = _filterByDiagnosis(allRecommendations, patient);

    return Scaffold(
      appBar: AppBar(
        title: Text(screenTitle),
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filtered.length,
        itemBuilder: (ctx, i) {
          final rec = filtered[i];
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
                // icono
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
                // título + descripción
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(rec.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(rec.shortDescription, style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
                // botón VER
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  child: const Text('Ver', style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    final activePlan = context.read<PatientProvider>().patient.activePlan;
                    final allowed = PlanHelper.userHasAccess(activePlan, categoryTitle);

                    if (!allowed) {
                      _promptUpgrade(context);
                      return;
                    }

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => RecommendationDetailScreen(recommendation: rec),
                      ),
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

  // ─────────────────────────────────────────────────────────────
  List<RecommendationModel> _filterByDiagnosis(List<RecommendationModel> list, PatientModel? patient) {
    if (patient?.diagnostico == null) return list;
    final diag = patient!.diagnostico!.toLowerCase().trim();
    return list.where((item) {
      if (item.targetDiagnoses.isEmpty) return true;
      return item.targetDiagnoses.map((d) => d.toLowerCase().trim()).contains(diag);
    }).toList();
  }
}
