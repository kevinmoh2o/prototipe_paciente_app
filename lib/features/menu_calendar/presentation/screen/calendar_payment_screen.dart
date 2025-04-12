import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:paciente_app/features/menu_calendar/presentation/provider/calendar_provider.dart';

class CalendarPaymentScreen extends StatelessWidget {
  final String appointmentId;

  const CalendarPaymentScreen({
    Key? key,
    required this.appointmentId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cp = Provider.of<CalendarProvider>(context, listen: false);
    final appt = cp.allAppointments.firstWhere(
      (a) => a.id == appointmentId,
      orElse: () => throw Exception("Cita no encontrada"),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pago de Cita"),
        backgroundColor: const Color(0xFF5B6BF5),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Vas a pagar la cita con ${appt.doctor.name}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Especialidad: ${appt.doctor.specialty}\n"
              "Fecha/Hora: ${_formatDate(appt.dateTime)} - ${_formatHour(appt.dateTime)}\n"
              "Tipo: ${appt.isTelemedicine ? "Telemedicina" : "Presencial"}\n",
              style: const TextStyle(fontSize: 14),
            ),
            const Spacer(),
            Text("Costo de la cita: S/ ${appt.fee.toStringAsFixed(2)}", style: const TextStyle(fontSize: 15)),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5B6BF5),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
              ),
              onPressed: () {
                // Marcar cita como pagada
                cp.markAppointmentAsPaid(appointmentId);

                // Regresar
                Navigator.of(context).pop();
                // O si prefieres ir al Home (o root), usar:
                // Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text("Pagar Ahora", style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
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
