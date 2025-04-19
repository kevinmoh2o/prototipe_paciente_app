/* import 'package:flutter/material.dart';
import 'package:paciente_app/features/planes/data/models/plan_model.dart';

class PlanCard extends StatelessWidget {
  final PlanModel plan;
  final VoidCallback onChoose;

  const PlanCard({Key? key, required this.plan, required this.onChoose}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // si discount=0.23 => "Ahorre 23%"
    final discountText = plan.discount != null ? "Ahorre ${(plan.discount! * 100).toStringAsFixed(0)}%" : null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, // o un color pastel
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            plan.title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          // Precios
          Text(
            "S/${plan.price.toStringAsFixed(2)} por mes",
            style: const TextStyle(fontSize: 16, color: Colors.indigo, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          // Descripción
          Text(
            plan.description,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          // Lista de beneficios
          for (final benefit in plan.benefits)
            Row(
              children: [
                const Icon(Icons.check, color: Colors.green, size: 16),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(benefit, style: const TextStyle(fontSize: 14, color: Colors.black87)),
                ),
              ],
            ),

          const SizedBox(height: 12),
          if (discountText != null)
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(discountText),
            ),

          const SizedBox(height: 8),
          SizedBox(
            width: 50,
            child: ElevatedButton(
              onPressed: onChoose,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text("Escoger Plan"),
            ),
          ),
        ],
      ),
    );
  }
}
 */
