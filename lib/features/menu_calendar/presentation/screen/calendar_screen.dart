import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:paciente_app/features/menu_calendar/presentation/provider/calendar_provider.dart';
import 'package:paciente_app/features/menu_calendar/presentation/widget/mini_calendar.dart';
import 'package:paciente_app/features/menu_calendar/presentation/widget/wizard/calendar_wizard.dart';
import 'package:paciente_app/features/menu_calendar/presentation/widget/appointment_list_tile.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cp = Provider.of<CalendarProvider>(context);
    const Color kPrimaryColor = Color(0xFF5B6BF5);

    return Scaffold(
      // AppBar sin leading, con color kPrimaryColor
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kPrimaryColor,
        elevation: 0,
      ),
      // Usamos AnimatedSwitcher para cambiar entre la vista “idle” y el wizard
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: cp.currentStep == CalendarFlowStep.idle
            ? _IdleView(key: const ValueKey("IdleView"))
            : const CalendarWizard(key: ValueKey("CalendarWizard")),
      ),
    );
  }
}

/// Vista “idle”: calendario + citas + botón “Reservar Cita”
class _IdleView extends StatelessWidget {
  const _IdleView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cp = Provider.of<CalendarProvider>(context);
    final appts = cp.appointmentsForSelectedDate;
    const Color kPrimaryColor = Color(0xFF5B6BF5);

    return SingleChildScrollView(
      key: const ValueKey("IdleMode"),
      child: Column(
        children: [
          // Sección superior: mini_calendar con color kPrimaryColor
          Container(
            color: kPrimaryColor,
            child: MiniCalendar(
              allAppointments: cp.allAppointments,
              selectedDate: cp.selectedDate,
              onSelectDate: (date) => cp.selectDate(date),
            ),
          ),
          const SizedBox(height: 16),

          // Lista de citas del día
          if (appts.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text("No tienes citas en esta fecha.", style: TextStyle(fontSize: 16)),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: appts.map((a) {
                  final timeStr = _formatHour(a.dateTime);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        timeStr,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54),
                      ),
                      const SizedBox(height: 4),
                      AppointmentListTile(appointment: a),
                      const SizedBox(height: 12),
                    ],
                  );
                }).toList(),
              ),
            ),

          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: cp.startScheduling,
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
            ),
            child: const Text("Reservar Cita", style: TextStyle(fontSize: 16)),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  String _formatHour(DateTime dt) {
    final h = dt.hour;
    final m = dt.minute.toString().padLeft(2, '0');
    final ampm = (h >= 12) ? "p.m." : "a.m.";
    final h12 = (h % 12 == 0) ? 12 : h % 12;
    return "$h12:$m $ampm";
  }
}
