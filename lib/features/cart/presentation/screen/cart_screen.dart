import 'package:flutter/material.dart';
import 'package:paciente_app/features/create_account/presentation/provider/patient_provider.dart';
import 'package:provider/provider.dart';

import 'package:paciente_app/features/cart/presentation/provider/cart_provider.dart';
import 'package:paciente_app/features/menu_calendar/presentation/provider/calendar_provider.dart';
import 'package:paciente_app/features/cart/data/services/payment_service.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProv = context.watch<CartProvider>();
    final calendarProv = context.watch<CalendarProvider>();

    final meds = cartProv.items;
    final appts = cartProv.appointmentItems;
    final plans = cartProv.planItems;
    final total = cartProv.grandTotal;

    Widget _sectionTitle(String t) => Padding(
          padding: const EdgeInsets.only(left: 16, top: 12, bottom: 4),
          child: Text(t, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        );

    return Scaffold(
      body: Column(
        children: [
          // ─────────── PLANES
          if (plans.isNotEmpty) ...[
            _sectionTitle('Planes'),
            Expanded(
              child: ListView.builder(
                itemCount: plans.length,
                itemBuilder: (_, i) {
                  final p = plans[i];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: p.color,
                      child: Icon(p.icon, color: Colors.white),
                    ),
                    title: Text(p.title),
                    subtitle: Text('S/ ${p.price.toStringAsFixed(2)}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_forever, color: Colors.red),
                      onPressed: () => cartProv.removePlan(p.title),
                    ),
                  );
                },
              ),
            ),
          ],

          // ─────────── CITAS
          if (appts.isNotEmpty) ...[
            _sectionTitle('Citas'),
            Expanded(
              child: ListView.builder(
                itemCount: appts.length,
                itemBuilder: (_, i) {
                  final a = appts[i];
                  return ListTile(
                    leading: const Icon(Icons.calendar_month),
                    title: Text('Cita con Dr. ${a.doctor.name}'),
                    subtitle: Text('Costo: S/ ${a.fee.toStringAsFixed(2)}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_forever, color: Colors.red),
                      onPressed: () {
                        // 1) sacar del carrito
                        cartProv.removeAppointmentFromCart(a.id);
                        // 2) quitarla del calendario
                        calendarProv.deleteAppointment(a.id);
                      },
                    ),
                  );
                },
              ),
            ),
          ],

          // ─────────── MEDICAMENTOS
          if (meds.isNotEmpty) ...[
            _sectionTitle('Medicamentos'),
            Expanded(
              child: ListView.builder(
                itemCount: meds.length,
                itemBuilder: (_, i) {
                  final c = meds[i];
                  return ListTile(
                    leading: Image.asset(c.medication.imageUrl, width: 40, fit: BoxFit.cover),
                    title: Text(c.medication.name),
                    subtitle: Text('Cantidad: ${c.quantity}'),
                    trailing: Text('S/ ${c.totalPrice.toStringAsFixed(2)}'),
                  );
                },
              ),
            ),
          ],

          if (plans.isEmpty && appts.isEmpty && meds.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Text('No hay artículos en el carrito.'),
            ),

          // ─────────── TOTAL + BOTÓN
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[200],
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('S/ ${total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  icon: const Icon(Icons.payment),
                  label: const Text('Pagar Todo'),
                  onPressed: total <= 0 ? null : () => _onPayEverything(context, cartProv, calendarProv, total),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5B6BF5),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────
  void _onPayEverything(BuildContext context, CartProvider cartProv, CalendarProvider calendarProv, double total) {
    final paymentMethods = PaymentService.getPaymentMethods();
    String? selectedMethod;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) => StatefulBuilder(
        builder: (stateCtx, setState) => Container(
          padding: const EdgeInsets.all(16),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text('Selecciona un método de pago', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SizedBox(
              height: 80,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: paymentMethods.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (_, idx) {
                  final pm = paymentMethods[idx];
                  final sel = selectedMethod == pm.name;
                  return GestureDetector(
                    onTap: () => setState(() => selectedMethod = pm.name),
                    child: Container(
                      width: 80,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: sel ? const Color(0xFF5B6BF5) : Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Image.asset(pm.assetIcon, width: 40, height: 40),
                        const SizedBox(height: 4),
                        Text(pm.name,
                            style: TextStyle(
                              fontSize: 12,
                              color: sel ? Colors.white : Colors.black87,
                              fontWeight: sel ? FontWeight.bold : FontWeight.normal,
                            ))
                      ]),
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
                      Navigator.pop(ctx);
                      _finishPayment(context, cartProv, calendarProv, selectedMethod!, total);
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5B6BF5),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              ),
              child: const Text('Pagar'),
            ),
          ]),
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────
  void _finishPayment(BuildContext context, CartProvider cartProv, CalendarProvider calendarProv, String method, double total) {
    // marcar citas como pagadas en ambos providers

    if (cartProv.planItems.isNotEmpty) {
      final patientProv = context.read<PatientProvider>();
      patientProv.setActivePlan(cartProv.planItems[0].title);
    }

    for (var appt in List.of(cartProv.appointmentItems)) {
      appt.isPaid = true;
      calendarProv.markAppointmentAsPaid(appt.id);
    }

    // limpiar carrito
    cartProv.clearCart();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Compra Exitosa'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Has pagado S/ ${total.toStringAsFixed(2)} con $method.'),
            const SizedBox(height: 8),
            const Text('¡Gracias por tu compra!', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
        ],
      ),
    );
  }
}
