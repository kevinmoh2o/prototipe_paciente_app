import 'package:flutter/material.dart';
import 'package:paciente_app/core/data/models/plan_data_model.dart';
import 'package:paciente_app/features/planes/presentation/screen/planes_screen.dart';

class FancyPlanCard extends StatelessWidget {
  final PlanData plan;
  final VoidCallback onChoose;

  const FancyPlanCard({
    Key? key,
    required this.plan,
    required this.onChoose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final discountText = plan.discount != null ? "Ahorre ${(plan.discount! * 100).toStringAsFixed(0)}%" : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            // Parte superior con un degradado / wave
            Container(
              height: 60,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF5B6BF5), Color(0xFF4051B5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                plan.title,
                style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "S/${plan.price.toStringAsFixed(2)} por mes",
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.indigo),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    plan.description,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  // Lista de beneficios
                  for (final b in plan.benefits)
                    Row(
                      children: [
                        const Icon(Icons.check, color: Colors.green, size: 16),
                        const SizedBox(width: 4),
                        Expanded(child: Text(b, style: const TextStyle(fontSize: 14))),
                      ],
                    ),
                  const SizedBox(height: 12),
                  // Botón discount
                  if (discountText != null)
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[600],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(discountText),
                    ),
                  const SizedBox(height: 8),
                  // Botón Escoger Plan
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: 120, // o lo que quieras
                      child: ElevatedButton(
                        onPressed: onChoose,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text("Escoger Plan"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
