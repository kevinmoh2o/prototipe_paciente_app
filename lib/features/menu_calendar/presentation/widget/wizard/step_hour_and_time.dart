import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:paciente_app/features/menu_calendar/presentation/provider/calendar_provider.dart';
import 'package:paciente_app/features/menu_calendar/presentation/widget/wizard/wizard_header.dart';
import 'package:paciente_app/features/menu_calendar/presentation/widget/day_time_toggle.dart';
import 'package:paciente_app/features/menu_calendar/presentation/widget/hour_grid_selector.dart';

class StepHourAndTime extends StatelessWidget {
  const StepHourAndTime({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cp = Provider.of<CalendarProvider>(context);

    return SingleChildScrollView(
      key: const ValueKey("StepHourAndDayTime"),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          WizardHeader(
            title: "Selecciona Turno y Hora",
            onBack: cp.backStep,
          ),
          const SizedBox(height: 8),

          // Toggle (mañana/tarde/noche)
          DayTimeToggle(
            currentValue: cp.selectedDayTime,
            onChanged: (dt) => cp.selectDayTime(dt),
          ),
          const SizedBox(height: 12),

          const Text("Horarios disponibles", style: TextStyle(fontSize: 13)),
          const SizedBox(height: 12),

          // Usa tu “HourGridSelector”
          HourGridSelector(
            selectedDayTime: cp.selectedDayTime,
            selectedHour: cp.selectedHour,
            onSelectHour: cp.selectHour,
          ),

          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: (cp.selectedHour == null) ? null : cp.nextStep,
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
