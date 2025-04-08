// lib/features/psicologico_espiritual/presentation/screen/psicologia_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:paciente_app/core/ui/alert_modal.dart';
import 'package:paciente_app/features/psicologico_espiritual/data/model/psicologia_option_model.dart';

class PsicologiaDetailScreen extends StatelessWidget {
  final PsicologiaOptionModel option;

  const PsicologiaDetailScreen({Key? key, required this.option}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(option.title),
        //backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.asset(option.imageAsset, height: 160),
            const SizedBox(height: 16),
            Text(
              option.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              option.description,
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Podrías simular la acción final: iniciar teleconsulta, etc.
                //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Iniciando ${option.title}...")));
                AlertModal.showAlert(
                  context,
                  color: Colors.green,
                  title: 'Iniciando: ',
                  description: option.title,
                  detail: 'Detalle opcional',
                  forceDialog: false, // false => SnackBar
                  snackbarDurationInSeconds: 5,
                );
              },
              child: const Text("Iniciar Sesión de Apoyo"),
            ),
          ],
        ),
      ),
    );
  }
}
