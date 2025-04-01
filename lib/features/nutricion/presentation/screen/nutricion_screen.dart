// nutricion_screen.dart
import 'package:flutter/material.dart';

class NutricionScreen extends StatelessWidget {
  const NutricionScreen({Key? key}) : super(key: key);

  // Sección enfocada en planes alimenticios, tips, recetarios, etc.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nutrición")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Un Banner
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  "Mejora tu alimentación",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Widget de contenido
            // Por ej. una lista de planes:
            // ...
          ],
        ),
      ),
    );
  }
}
