// lib/features/nutricion/presentation/screen/consulta_nutri_screen.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:paciente_app/core/ui/alert_modal.dart';
import 'package:provider/provider.dart';
import 'package:paciente_app/features/nutricion/presentation/provider/nutricion_provider.dart';

class ConsultaNutriScreen extends StatelessWidget {
  const ConsultaNutriScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nutriProv = context.watch<NutricionProvider>();
    final docs = nutriProv.nutriDoctors;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Consulta con Nutriólogo"),
        backgroundColor: Colors.orange,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: docs.length,
        itemBuilder: (ctx, i) {
          final doc = docs[i];
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
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text("${doc.rating}★"),
                          const SizedBox(width: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: doc.isOnline ? Colors.green : Colors.grey,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            child: Text(
                              doc.isOnline ? "Online" : "Offline",
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.video_call, color: Colors.blue),
                      onPressed: () {
                        AlertModal.showAlert(
                          context,
                          color: Colors.blue,
                          title: 'Videollamada con: ',
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
                        AlertModal.showAlert(
                          context,
                          color: Colors.green,
                          title: 'WhatsApp a: ',
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
