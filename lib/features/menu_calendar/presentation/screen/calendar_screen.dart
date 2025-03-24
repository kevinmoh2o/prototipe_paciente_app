import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:paciente_app/features/menu_calendar/presentation/provider/calendar_provider.dart';
import 'package:paciente_app/features/menu_calendar/presentation/widget/mini_calendar.dart';
import 'package:paciente_app/features/menu_calendar/presentation/widget/calendar_wizard.dart';
import 'package:paciente_app/features/menu_calendar/presentation/widget/appointment_list_tile.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cp = Provider.of<CalendarProvider>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // sin flecha
        title: const Text("Calendario"),
        backgroundColor: kPrimaryColor,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Calendario
          Container(
            color: kPrimaryColor,
            child: MiniCalendar(
              selectedDate: cp.selectedDate,
              onSelectDate: cp.selectDate,
            ),
          ),
          // Contenido
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: cp.currentStep == CalendarFlowStep.idle ? _buildDailyAppointments(context, cp) : const CalendarWizard(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyAppointments(BuildContext context, CalendarProvider cp) {
    final appts = cp.appointmentsForSelectedDate;

    return SingleChildScrollView(
      key: const ValueKey("IdleMode"),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (appts.isEmpty)
            const Text("No tienes citas en esta fecha.", style: TextStyle(fontSize: 16))
          else
            Column(
              children: appts.map((a) {
                final timeLabel = _formatHour(a.dateTime);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        timeLabel,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54),
                      ),
                      const SizedBox(height: 4),
                      AppointmentListTile(appointment: a),
                    ],
                  ),
                );
              }).toList(),
            ),
          const SizedBox(height: 24),
          Center(
            child: ElevatedButton(
              onPressed: cp.startScheduling,
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
              ),
              child: const Text("Reservar Cita", style: TextStyle(fontSize: 16)),
            ),
          )
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
