import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:paciente_app/features/cart/presentation/provider/cart_provider.dart';
import 'package:paciente_app/features/menu_calendar/presentation/provider/calendar_provider.dart';
import 'package:paciente_app/features/cart/data/services/payment_service.dart';
import 'package:paciente_app/features/cart/data/models/payment_method_model.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProv = context.watch<CartProvider>();
    final calendarProv = context.watch<CalendarProvider>(); // Para actualizar estado en calendario
    final items = cartProv.items; // Medicamentos
    final appts = cartProv.appointmentItems; // Citas

    final total = cartProv.grandTotal;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Carrito"),
        backgroundColor: const Color(0xFF5B6BF5),
      ),
      body: Column(
        children: [
          // Lista de CITAS
          if (appts.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: appts.length,
                itemBuilder: (_, i) {
                  final apt = appts[i];
                  return ListTile(
                    leading: const Icon(Icons.calendar_month),
                    title: Text("Cita con Dr. ${apt.doctor.name}"),
                    subtitle: Text("Costo: S/ ${apt.fee.toStringAsFixed(2)}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => cartProv.removeAppointmentFromCart(apt.id),
                    ),
                  );
                },
              ),
            )
          else
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("No hay citas en el carrito."),
            ),

          // Lista de MEDICAMENTOS
          if (items.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (_, i) {
                  final cartItem = items[i];
                  return ListTile(
                    leading: Image.asset(cartItem.medication.imageUrl, width: 40, fit: BoxFit.cover),
                    title: Text(cartItem.medication.name),
                    subtitle: Text("Cantidad: ${cartItem.quantity}"),
                    trailing: Text("S/ ${cartItem.totalPrice.toStringAsFixed(2)}"),
                  );
                },
              ),
            )
          else
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("No hay medicamentos en el carrito."),
            ),

          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[200],
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Total:", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("S/ ${total.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: (total <= 0) ? null : () => _onPayEverything(context, cartProv, calendarProv, total),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5B6BF5),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  ),
                  child: const Text("Pagar Todo"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onPayEverything(
    BuildContext context,
    CartProvider cartProv,
    CalendarProvider calendarProv,
    double total,
  ) {
    final paymentMethods = PaymentService.getPaymentMethods();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        String? selectedMethod;

        return StatefulBuilder(
          builder: (stateCtx, setState) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Selecciona un método de pago",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 80,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: paymentMethods.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (_, index) {
                        final pm = paymentMethods[index];
                        final isSelected = (selectedMethod == pm.name);

                        return GestureDetector(
                          onTap: () => setState(() => selectedMethod = pm.name),
                          child: Container(
                            width: 80,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFF5B6BF5) : Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(pm.assetIcon, width: 40, height: 40),
                                const SizedBox(height: 4),
                                Text(
                                  pm.name,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isSelected ? Colors.white : Colors.black87,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: selectedMethod == null
                        ? null
                        : () {
                            Navigator.pop(ctx); // cierra bottomSheet
                            _doFinalPayment(context, cartProv, calendarProv, selectedMethod!, total);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5B6BF5),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    ),
                    child: const Text("Pagar"),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _doFinalPayment(
    BuildContext context,
    CartProvider cartProv,
    CalendarProvider calendarProv,
    String method,
    double total,
  ) {
    // Marcamos las citas como pagadas en ambos Providers
    for (var appt in cartProv.appointmentItems) {
      appt.isPaid = true; // local
      calendarProv.markAppointmentAsPaid(appt.id); // Calendario
    }

    // Limpia solo citas (ya pagadas)
    cartProv.appointmentItems.clear();
    cartProv.items.clear();

    // También podrías vaciar medicamentos si los consideras pagados.
    // cartProv.items.clear();
    cartProv.notifyListeners();

    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text("Compra Exitosa"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Has pagado S/ ${total.toStringAsFixed(2)} con $method."),
              const SizedBox(height: 8),
              const Text("¡Gracias por tu compra!", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogCtx);
                // Regresar a donde quieras
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
