// lib/features/aptitud_fisica/presentation/screen/aptitud_screen.dart

import 'package:flutter/material.dart';
import 'package:paciente_app/features/aptitud_fisica/presentation/screen/evaluacion_rutina_screen.dart';
import 'package:paciente_app/features/aptitud_fisica/presentation/screen/consulta_entrenador_screen.dart';
import 'package:paciente_app/features/aptitud_fisica/presentation/screen/rutinas_screen.dart';
import 'package:paciente_app/features/aptitud_fisica/presentation/screen/grupos_aptitud_screen.dart';

class AptitudScreen extends StatelessWidget {
  const AptitudScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Aptitud Física Oncológica"),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _AptitudSectionCard(
              title: "Evaluación de Rutina",
              subtitle: "Completa un cuestionario sobre tus ejercicios y limitaciones",
              icon: Icons.fitness_center,
              color: Colors.purple,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EvaluacionRutinaScreen()),
                );
              },
            ),
            /* const SizedBox(height: 12),
            _AptitudSectionCard(
              title: "Consulta con Entrenador",
              subtitle: "Asesórate con especialistas en ejercicio adaptado",
              icon: Icons.run_circle,
              color: Colors.blueAccent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ConsultaEntrenadorScreen()),
                );
              },
            ), */
            const SizedBox(height: 12),
            _AptitudSectionCard(
              title: "Rutinas Recomendadas",
              subtitle: "Ver ejercicios adaptados y planes",
              icon: Icons.directions_walk,
              color: Colors.teal,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RutinasScreen()),
                );
              },
            ),
            const SizedBox(height: 12),
            _AptitudSectionCard(
              title: "Grupos de Aptitud",
              subtitle: "Comparte avances y motívate con otros pacientes",
              icon: Icons.group,
              color: Colors.orange,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GruposAptitudScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _AptitudSectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _AptitudSectionCard({Key? key, required this.title, required this.subtitle, required this.icon, required this.color, required this.onTap})
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
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(fontSize: 13, color: Colors.black54)),
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
