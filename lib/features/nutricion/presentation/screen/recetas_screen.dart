// lib/features/nutricion/presentation/screen/recetas_screen.dart

import 'package:flutter/material.dart';
import 'package:paciente_app/core/data/models/patient_model.dart';
import 'package:paciente_app/core/data/models/recommendation_model.dart';
import 'package:paciente_app/core/ui/alert_modal.dart';
import 'package:paciente_app/core/widgets/recommendation_list_screen.dart';
import 'package:provider/provider.dart';
import 'package:paciente_app/features/nutricion/presentation/provider/nutricion_provider.dart';

class RecetasScreen extends StatelessWidget {
  const RecetasScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nutriProv = context.watch<NutricionProvider>();
    final recetas = nutriProv.recetas;

    final PatientModel? paciente = /* recupera tu paciente con SharedPrefs o Provider */ null;

    // Suponiendo que definiste en algún lado:
    final List<RecommendationModel> miListaDeRutinas = nutriProv.recetasRecommendations;

    return RecommendationListScreen(
      screenTitle: "Recetas Saludables",
      iconData: Icons.restaurant,
      iconBgColor: Colors.green.shade50,
      iconColor: Colors.green,
      allRecommendations: miListaDeRutinas,
      patient: paciente, // para filtrar por diagnóstico
      categoryTitle: "Nutrición",
    );

    /* return Scaffold(
      appBar: AppBar(
        title: const Text("Recetas Saludables"),
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: recetas.length,
        itemBuilder: (ctx, i) {
          final rec = recetas[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              )
            ]),
            child: Row(
              children: [
                // Podrías colocar una imagen genérica
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.restaurant, color: Colors.green),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    rec,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Podrías mostrar más detalles de la receta
                    AlertModal.showAlert(
                      context,
                      color: Colors.blue,
                      title: 'Mostrando detalles de: ',
                      description: rec,
                      detail: 'Detalle opcional',
                      forceDialog: false, // false => SnackBar
                      snackbarDurationInSeconds: 5,
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
                  child: const Text("Ver"),
                )
              ],
            ),
          );
        },
      ),
    ); */
  }
}
