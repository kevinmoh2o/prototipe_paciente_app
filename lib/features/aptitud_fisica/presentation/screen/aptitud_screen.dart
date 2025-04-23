// lib/features/aptitud_fisica/presentation/screen/aptitud_screen.dart
import 'package:flutter/material.dart';
import 'package:paciente_app/features/aptitud_fisica/presentation/screen/evaluacion_rutina_screen.dart';
import 'package:paciente_app/features/aptitud_fisica/presentation/screen/consulta_entrenador_screen.dart';
import 'package:paciente_app/features/aptitud_fisica/presentation/screen/rutinas_screen.dart';
import 'package:paciente_app/features/aptitud_fisica/presentation/screen/grupos_aptitud_screen.dart';
import 'package:paciente_app/features/main_navigation/screen/main_navigation_screen.dart';

class AptitudScreen extends StatelessWidget {
  final bool isLocked;
  final VoidCallback? onUpgrade;
  const AptitudScreen({Key? key, this.isLocked = false, this.onUpgrade}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Aptitud Física Oncológica"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _AptitudSectionCard(
                  title: "Evaluación de Rutina",
                  subtitle: "Completa un cuestionario sobre tus ejercicios y limitaciones",
                  icon: Icons.fitness_center,
                  color: Colors.purple,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EvaluacionRutinaScreen())),
                ),
                const SizedBox(height: 12),
                _AptitudSectionCard(
                  title: "Rutinas Recomendadas",
                  subtitle: "Ver ejercicios adaptados y planes",
                  icon: Icons.directions_walk,
                  color: Colors.teal,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RutinasScreen())),
                ),
                const SizedBox(height: 12),
                _AptitudSectionCard(
                  title: "Grupos de Aptitud",
                  subtitle: "Comparte avances y motívate con otros pacientes",
                  icon: Icons.group,
                  color: Colors.orange,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GruposAptitudScreen())),
                ),
                const SizedBox(height: 12),
                _AptitudSectionCard(
                  title: "Consulta con Entrenador",
                  subtitle: "Asesórate con especialistas en ejercicio adaptado",
                  icon: Icons.run_circle,
                  color: Colors.blueAccent,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MainNavigationScreen(currentIndex: 1)),
                  ),
                ),
              ],
            ),
          ),

          // Capa de bloqueo + tarjeta upgrade
          if (isLocked) ...[
            // oscurece y bloquea el contenido
            ModalBarrier(
              color: Colors.black.withOpacity(0.55),
              dismissible: false,
            ),
            // tarjeta interactiva (no está dentro del ModalBarrier, por eso funciona el botón)
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
                    const Icon(Icons.lock_outline, size: 56, color: Colors.deepPurple),
                    const SizedBox(height: 16),
                    const Text("Contenido exclusivo", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text(
                      "Actualiza tu plan para acceder a ejercicios, grupos y consultas de aptitud.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.upgrade_rounded),
                      label: const Text("Mejorar plan"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      ),
                      onPressed: onUpgrade ??
                          () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const MainNavigationScreen(
                                          currentIndex: 2,
                                          planesInitialIndex: 4,
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

class _AptitudSectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _AptitudSectionCard({
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
