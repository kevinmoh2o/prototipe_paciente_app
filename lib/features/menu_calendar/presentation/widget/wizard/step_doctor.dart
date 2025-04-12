import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:paciente_app/features/menu_calendar/presentation/provider/calendar_provider.dart';
import 'package:paciente_app/features/menu_calendar/presentation/widget/wizard/wizard_header.dart';

class StepDoctor extends StatelessWidget {
  const StepDoctor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cp = Provider.of<CalendarProvider>(context);
    final docs = cp.filteredDoctors;

    return SingleChildScrollView(
      key: const ValueKey("StepDoctor"),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          WizardHeader(
            title: "Selecciona Especialista",
            onBack: cp.backStep,
          ),
          const SizedBox(height: 16),
          if (docs.isEmpty)
            const Text("No hay doctores disponibles para esta categoría.")
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: docs.length,
              itemBuilder: (ctx, i) {
                final doc = docs[i];
                final isSelected = (cp.selectedDoctor == doc);
                return GestureDetector(
                  onTap: () => cp.selectDoctor(doc),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF5B6BF5).withOpacity(0.1) : Colors.white,
                      border: Border.all(
                        color: isSelected ? const Color(0xFF5B6BF5) : Colors.grey[300]!,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage(doc.profileImage),
                          radius: 24,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(doc.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text(doc.specialty, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                              Row(
                                children: [
                                  const Icon(Icons.star, color: Colors.amber, size: 14),
                                  const SizedBox(width: 4),
                                  Text("${doc.rating} (${doc.reviewsCount} Reviews)", style: const TextStyle(fontSize: 12)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (isSelected) const Icon(Icons.check_circle, color: Color(0xFF5B6BF5))
                      ],
                    ),
                  ),
                );
              },
            ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: cp.selectedDoctor == null ? null : cp.nextStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF5B6BF5),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text("Siguiente", style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
