// lib/features/aptitud_fisica/presentation/screen/rutinas_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:paciente_app/features/aptitud_fisica/presentation/provider/aptitud_provider.dart';

class RutinasScreen extends StatelessWidget {
  const RutinasScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final aptProv = context.watch<AptitudProvider>();
    final rutinas = aptProv.rutinas;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Rutinas Recomendadas"),
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: rutinas.length,
        itemBuilder: (ctx, i) {
          final rut = rutinas[i];
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
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.fitness_center, color: Colors.green),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(rut, style: const TextStyle(fontSize: 14)),
                ),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Detalles de: $rut")));
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  child: const Text("Ver", style: TextStyle(color: Colors.white)),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
