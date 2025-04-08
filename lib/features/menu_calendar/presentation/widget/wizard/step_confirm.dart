import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:paciente_app/features/menu_calendar/presentation/provider/calendar_provider.dart';
import 'package:paciente_app/features/menu_calendar/presentation/widget/wizard/wizard_header.dart';

class StepConfirm extends StatelessWidget {
  const StepConfirm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cp = Provider.of<CalendarProvider>(context);
    final dt = cp.newAppointmentDateTime;
    final doc = cp.selectedDoctor;

    return SingleChildScrollView(
      key: const ValueKey("StepConfirm"),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          WizardHeader(
            title: "Confirmar Cita",
            onBack: cp.backStep,
          ),
          const SizedBox(height: 16),
          if (dt == null || doc == null)
            const Text("Faltan datos para confirmar.")
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Fecha/Hora: ${_formatDate(dt)} - ${_formatHour(dt)}",
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage(doc.profileImage),
                      radius: 24,
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(doc.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text(doc.specialty, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    )
                  ],
                ),
              ],
            ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => cp.confirmAppointment(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text("Confirmar Cita", style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    const months = ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"];
    final m = months[dt.month - 1];
    return "${dt.day} de $m ${dt.year}";
  }

  String _formatHour(DateTime dt) {
    final h = dt.hour;
    final min = dt.minute.toString().padLeft(2, '0');
    final ampm = (h >= 12) ? "p.m." : "a.m.";
    final h12 = (h % 12 == 0) ? 12 : h % 12;
    return "$h12:$min $ampm";
  }
}
