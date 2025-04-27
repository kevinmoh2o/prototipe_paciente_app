/* import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:paciente_app/features/menu_calendar/presentation/provider/calendar_provider.dart';
import 'package:paciente_app/features/cart/presentation/provider/cart_provider.dart';
import 'package:paciente_app/features/main_navigation/screen/main_navigation_screen.dart';

class _StepConfirm extends StatelessWidget {
  const _StepConfirm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final calendarProv = context.watch<CalendarProvider>();
    final dt = calendarProv.newAppointmentDateTime;
    final doc = calendarProv.selectedDoctor;

    return SingleChildScrollView(
      key: const ValueKey("StepConfirm"),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          _WizardHeader(
            title: "Confirmar Cita",
            onBack: calendarProv.backStep,
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
                        Text(
                          doc.specialty,
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        Text("Tarifa: S/ ${doc.consultationFee.toStringAsFixed(2)}"),
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
                  onPressed: () => _onConfirmPressed(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5B6BF5),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text("Confirmar Cita", style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _onConfirmPressed(BuildContext context) {
    // 1) Obtenemos el CalendarProvider y confirmamos la cita
    final calendarProv = context.read<CalendarProvider>();
    final newAppt = calendarProv.confirmAppointment();
    if (newAppt == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No se pudo confirmar la cita.")),
      );
      return;
    }

    // 2) Obtenemos el CartProvider aquí (context válido)
    final cartProv = context.read<CartProvider>();

    // 3) Mostramos el diálogo para “Agregar al Carrito” o “Pagar Ahora”
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) {
        return AlertDialog(
          title: const Text("¿Deseas pagar ahora?"),
          content: Text(
            "La cita con ${newAppt.doctor.name} tiene un costo de S/ ${newAppt.fee.toStringAsFixed(2)}.\n"
            "¿Pagar ahora o agregar al carrito?",
          ),
          actions: [
            // ─────────────────────────────────────────────
            // Botón: AGREGAR AL CARRITO
            TextButton(
              onPressed: () {
                // Cerramos diálogo
                Navigator.pop(dialogCtx);

                // Agregamos la cita al carrito
                cartProv.addToCartAppointment(newAppt);

                // Navegar a la pestaña de Carrito (index=4)
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MainNavigationScreen(initialTab: NavigationTab.cart),
                  ),
                );
              },
              child: const Text("Agregar al Carrito"),
            ),

            // ─────────────────────────────────────────────
            // Botón: PAGAR AHORA
            ElevatedButton(
              onPressed: () {
                // Cerramos diálogo
                Navigator.pop(dialogCtx);

                // Marcamos la cita como pagada
                calendarProv.markAppointmentAsPaid(newAppt.id);

                // MOSTRAR MENSAJE (opcional)
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Cita pagada con éxito (S/ ${newAppt.fee.toStringAsFixed(2)}).",
                    ),
                  ),
                );

                // Por ejemplo, volver al home (index=0)
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MainNavigationScreen(currentIndex: 0),
                  ),
                );
              },
              child: const Text("Pagar Ahora"),
            ),
          ],
        );
      },
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

/// Puedes moverlo a otro archivo si ya tienes un WizardHeader
class _WizardHeader extends StatelessWidget {
  final String title;
  final VoidCallback onBack;

  const _WizardHeader({
    Key? key,
    required this.title,
    required this.onBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: onBack,
        ),
        Expanded(
          child: Center(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(width: 40),
      ],
    );
  }
}
 */
