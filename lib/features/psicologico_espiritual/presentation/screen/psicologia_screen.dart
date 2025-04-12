// lib/features/psicologico_espiritual/presentation/screen/psicologia_screen.dart

import 'package:flutter/material.dart';
import 'package:paciente_app/features/psicologico_espiritual/presentation/screen/evaluacion_inicial_screen.dart';
import 'package:paciente_app/features/psicologico_espiritual/presentation/screen/consulta_psicologica_screen.dart';
import 'package:paciente_app/features/psicologico_espiritual/presentation/screen/apoyo_espiritual_screen.dart';
import 'package:paciente_app/features/psicologico_espiritual/presentation/screen/grupos_apoyo_screen.dart';

class PsicologiaScreen extends StatelessWidget {
  const PsicologiaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Apoyo Psicológico y Espiritual"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _SectionCard(
              title: "Evaluación Inicial",
              subtitle: "Completa un cuestionario para conocer tu estado emocional.",
              icon: Icons.quiz,
              color: Colors.purple,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EvaluacionInicialScreen()),
                );
              },
            ),
            /* const SizedBox(height: 12),
            _SectionCard(
              title: "Consulta Psicológica",
              subtitle: "Habla con psicólogos en vivo para asesoría",
              icon: Icons.psychology,
              color: Colors.orange,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ConsultaPsicologicaScreen()),
                );
              },
            ), */
            const SizedBox(height: 12),
            _SectionCard(
              title: "Apoyo Espiritual",
              subtitle: "Recursos motivacionales y consejería espiritual.",
              icon: Icons.sunny_snowing,
              color: Colors.teal,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ApoyoEspiritualScreen()),
                );
              },
            ),
            const SizedBox(height: 12),
            _SectionCard(
              title: "Grupos de Apoyo",
              subtitle: "Interactúa con otros pacientes, comparte y recibe comentarios.",
              icon: Icons.group,
              color: Colors.blueGrey,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GruposApoyoScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _SectionCard({Key? key, required this.title, required this.subtitle, required this.icon, required this.color, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey)
          ],
        ),
      ),
    );
  }
}
