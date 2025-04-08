// lib/features/psicologico_espiritual/presentation/screen/apoyo_espiritual_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:paciente_app/features/psicologico_espiritual/presentation/provider/psicologia_provider.dart';

class ApoyoEspiritualScreen extends StatelessWidget {
  const ApoyoEspiritualScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final psyProv = context.watch<PsicologiaProvider>();
    final recursos = psyProv.recursosEspirituales;

    return Scaffold(
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
    );
  }
}
