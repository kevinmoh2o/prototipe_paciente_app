// lib/features/psicologico_espiritual/presentation/screen/consulta_psicologica_screen.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:paciente_app/core/ui/alert_modal.dart';
import 'package:provider/provider.dart';
import 'package:paciente_app/features/psicologico_espiritual/presentation/provider/psicologia_provider.dart';

class ConsultaPsicologicaScreen extends StatelessWidget {
  const ConsultaPsicologicaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final psyProv = context.watch<PsicologiaProvider>();
    final psicologos = psyProv.psicologos;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Consulta Psicológica"),
        backgroundColor: Colors.orange,
      ),
      body: ListView.builder(
        itemCount: psicologos.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (ctx, i) {
          final doc = psicologos[i];
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
                CircleAvatar(
                  backgroundImage: AssetImage(doc.imageAsset),
                  radius: 30,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(doc.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 16, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text("${doc.rating.toStringAsFixed(1)}★"),
                          const SizedBox(width: 8),
                          if (doc.isOnline)
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              child: const Text("Online", style: TextStyle(color: Colors.white, fontSize: 12)),
                            )
                          else
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              child: const Text("Offline", style: TextStyle(color: Colors.white, fontSize: 12)),
                            )
                        ],
                      )
                    ],
                  ),
                ),
                // Botones de videollamada y whatsapp
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.video_call, color: Colors.blue),
                      onPressed: () {
                        // Simular videollamada
                        //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Iniciando videollamada con ${doc.name}...")));
                        AlertModal.showAlert(
                          context,
                          color: Colors.blue,
                          title: 'Iniciando videollamada con',
                          description: doc.name,
                          detail: 'Detalle opcional',
                          forceDialog: false, // false => SnackBar
                          snackbarDurationInSeconds: 5,
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(FontAwesomeIcons.whatsapp, color: Colors.green),
                      onPressed: () {
                        //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Abriendo chat de WhatsApp con ${doc.name}...")));
                        AlertModal.showAlert(
                          context,
                          color: Colors.green,
                          title: 'Abriendo chat de WhatsApp con',
                          description: doc.name,
                          detail: 'Detalle opcional',
                          forceDialog: false, // false => SnackBar
                          snackbarDurationInSeconds: 5,
                        );
                      },
                    )
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
