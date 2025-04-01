// aptitud_screen.dart
import 'package:flutter/material.dart';

class AptitudScreen extends StatelessWidget {
  const AptitudScreen({Key? key}) : super(key: key);

  // Sección con rutinas de ejercicios, etc.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Aptitud Física")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Banner / imagen
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  "Mejora tu estilo de vida",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Sección: rutinas, tips, etc.
          ],
        ),
      ),
    );
  }
}
