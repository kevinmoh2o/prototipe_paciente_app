// lib/features/psicologico_espiritual/presentation/screen/psicologia_screen.dart
import 'package:flutter/material.dart';
import 'package:paciente_app/features/main_navigation/screen/main_navigation_screen.dart';
import 'package:paciente_app/features/psicologico_espiritual/presentation/screen/evaluacion_inicial_screen.dart';
import 'package:paciente_app/features/psicologico_espiritual/presentation/screen/apoyo_espiritual_screen.dart';
import 'package:paciente_app/features/psicologico_espiritual/presentation/screen/grupos_apoyo_screen.dart';

class PsicologiaScreen extends StatelessWidget {
  final bool isLocked;
  final VoidCallback? onUpgrade;
  const PsicologiaScreen({Key? key, this.isLocked = false, this.onUpgrade}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Apoyo Psicológico y Espiritual"),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _SectionCard(
                  title: "Evaluación Inicial",
                  subtitle: "Completa un cuestionario para conocer tu estado emocional.",
                  icon: Icons.quiz,
                  color: Colors.purple,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EvaluacionInicialScreen())),
                ),
                const SizedBox(height: 12),
                _SectionCard(
                  title: "Apoyo Espiritual",
                  subtitle: "Recursos motivacionales y consejería espiritual.",
                  icon: Icons.sunny_snowing,
                  color: Colors.teal,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ApoyoEspiritualScreen())),
                ),
                const SizedBox(height: 12),
                _SectionCard(
                  title: "Grupos de Apoyo",
                  subtitle: "Interactúa con otros pacientes, comparte y recibe comentarios.",
                  icon: Icons.group,
                  color: Colors.blueGrey,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GruposApoyoScreen())),
                ),
                const SizedBox(height: 12),
                _SectionCard(
                  title: "Consulta Psicológica",
                  subtitle: "Habla con psicólogos en vivo para asesoría",
                  icon: Icons.psychology,
                  color: Colors.orange,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MainNavigationScreen(currentIndex: 1)),
                  ),
                ),
              ],
            ),
          ),
          if (isLocked) ...[
            ModalBarrier(
              color: Colors.black.withOpacity(0.55),
              dismissible: false,
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 32),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 12, offset: Offset(0, 6))],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.lock_outline, size: 56, color: Colors.blue),
                    const SizedBox(height: 16),
                    const Text("Contenido exclusivo", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text(
                      "Actualiza tu plan para acceder a evaluaciones, grupos y consultas psicológicas.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.upgrade_rounded),
                      label: const Text("Mejorar plan"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      ),
                      onPressed: onUpgrade ??
                          () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const MainNavigationScreen(
                                          currentIndex: 2,
                                          planesInitialIndex: 2,
                                        )),
                              ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
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
  const _SectionCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
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
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
