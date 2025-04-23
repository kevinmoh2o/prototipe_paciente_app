// lib/features/nutricion/presentation/screen/nutricion_screen.dart
import 'package:flutter/material.dart';
import 'package:paciente_app/features/main_navigation/screen/main_navigation_screen.dart';
import 'package:paciente_app/features/nutricion/presentation/screen/evaluacion_nutricional_screen.dart';
import 'package:paciente_app/features/nutricion/presentation/screen/consulta_nutri_screen.dart';
import 'package:paciente_app/features/nutricion/presentation/screen/recetas_screen.dart';
import 'package:paciente_app/features/nutricion/presentation/screen/grupos_nutricion_screen.dart';

class NutricionScreen extends StatelessWidget {
  final bool isLocked;
  final VoidCallback? onUpgrade;
  const NutricionScreen({Key? key, this.isLocked = false, this.onUpgrade}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nutrición y Alimentación"),
        backgroundColor: Colors.green,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _NutriSectionCard(
                  title: "Evaluación Nutricional",
                  subtitle: "Completa un cuestionario sobre tus hábitos alimenticios",
                  icon: Icons.quiz,
                  color: Colors.purple,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EvaluacionNutricionalScreen())),
                ),
                const SizedBox(height: 12),
                _NutriSectionCard(
                  title: "Recetas Saludables",
                  subtitle: "Planes alimenticios y recetas",
                  icon: Icons.restaurant_menu,
                  color: Colors.teal,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RecetasScreen())),
                ),
                const SizedBox(height: 12),
                _NutriSectionCard(
                  title: "Grupos de Nutrición",
                  subtitle: "Comparte tips y recetas con otros pacientes",
                  icon: Icons.group,
                  color: Colors.blueGrey,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GruposNutricionScreen())),
                ),
                const SizedBox(height: 12),
                _NutriSectionCard(
                  title: "Consulta con Nutriólogo",
                  subtitle: "Habla con expertos en nutrición en vivo",
                  icon: Icons.medical_services,
                  color: Colors.orange,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MainNavigationScreen(currentIndex: 1))),
                ),
              ],
            ),
          ),

          // capa de bloqueo + tarjeta interactiva
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
                    const Icon(Icons.lock_outline, size: 56, color: Colors.green),
                    const SizedBox(height: 16),
                    const Text("Contenido exclusivo", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text(
                      "Actualiza tu plan para disfrutar de todas las funcionalidades.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.upgrade_rounded),
                      label: const Text("Mejorar plan"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      ),
                      onPressed: onUpgrade ??
                          () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const MainNavigationScreen(
                                          currentIndex: 2,
                                          planesInitialIndex: 3,
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

class _NutriSectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _NutriSectionCard({
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
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
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
