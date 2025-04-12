import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:paciente_app/features/menu_calendar/presentation/provider/calendar_provider.dart';
import 'package:paciente_app/features/menu_calendar/presentation/widget/mini_calendar.dart';
import 'package:paciente_app/features/menu_calendar/presentation/widget/appointment_list_tile.dart';
import 'package:paciente_app/features/menu_calendar/presentation/widget/wizard/calendar_wizard.dart';

class CalendarScreen extends StatelessWidget {
  final bool isarrowBackActive;
  const CalendarScreen({Key? key, required this.isarrowBackActive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cp = context.watch<CalendarProvider>();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: isarrowBackActive,
        backgroundColor: const Color(0xFF5B6BF5),
        title: const Text("Calendario"),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: (cp.currentStep == CalendarFlowStep.idle)
            ? const _IdleCalendarView(key: ValueKey("IdleView"))
            : const CalendarWizard(key: ValueKey("CalendarWizard")),
      ),
    );
  }
}

class _IdleCalendarView extends StatelessWidget {
  const _IdleCalendarView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cp = context.watch<CalendarProvider>();
    final appts = cp.appointmentsForSelectedDate;

    return SingleChildScrollView(
      child: Column(
        children: [
          // Sección superior: MiniCalendar
          Container(
            color: const Color(0xFF5B6BF5),
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: MiniCalendar(
              selectedDate: cp.selectedDate,
              allAppointments: cp.allAppointments,
              onSelectDate: (date) => cp.selectDate(date),
            ),
          ),
          const SizedBox(height: 16),

          if (appts.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text("No tienes citas en esta fecha.", style: TextStyle(fontSize: 16)),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: appts.map((a) {
                  final timeStr = _formatHour(a.dateTime);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        timeStr,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
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
          // BOTÓN => Wizard normal
          ElevatedButton(
            onPressed: () {
              cp.startScheduling(
                  // sin forzar nada => pedirá cat + doc
                  );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5B6BF5),
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
