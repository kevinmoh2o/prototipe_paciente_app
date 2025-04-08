import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:paciente_app/features/menu_calendar/presentation/provider/calendar_provider.dart';
import 'package:paciente_app/features/menu_calendar/presentation/widget/wizard/wizard_header.dart';
import 'package:paciente_app/features/menu_calendar/presentation/widget/consultation_type_toggle.dart';

class StepCategory extends StatelessWidget {
  const StepCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cp = Provider.of<CalendarProvider>(context);

    return SingleChildScrollView(
      key: const ValueKey("StepCategory"),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          WizardHeader(
            title: "Tipo de Consulta",
            onBack: cp.backStep,
          ),
          const SizedBox(height: 16),

          // ConsultationTypeToggle
          ConsultationTypeToggle(
            currentValue: cp.selectedCategory,
            onChanged: (cat) => cp.selectCategory(cat),
          ),

          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: cp.selectedCategory == null ? null : cp.nextStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
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
