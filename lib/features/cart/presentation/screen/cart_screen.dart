import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:paciente_app/features/cart/presentation/provider/cart_provider.dart';
import 'package:paciente_app/features/create_account/presentation/provider/patient_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProv = context.watch<CartProvider>();
    final patientProv = context.watch<PatientProvider>();
    final items = cartProv.items;
    final planName = patientProv.patient.activePlan;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrito de Compras'),
      ),
      body: items.isEmpty
          ? const Center(child: Text('Carrito vacío'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (_, i) {
                      final item = items[i];
                      return ListTile(
                        leading: Image.asset(item.medication.imageUrl, width: 50),
                        title: Text(item.medication.name),
                        subtitle: Text('Cantidad: ${item.quantity}\n'
                            'Precio c/u: S/${item.medication.price.toStringAsFixed(2)}'),
                        trailing: Text('Total: S/${item.totalPrice.toStringAsFixed(2)}'),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Subtotal:', style: TextStyle(fontSize: 16)),
                      Text('S/${cartProv.subtotal.toStringAsFixed(2)}'),
                    ],
                  ),
                ),
                if (planName != null) ...[
                  // si el usuario tiene un plan, muestra el descuento
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Descuento por $planName:', style: const TextStyle(fontSize: 16)),
                        Text('- ${(cartProv.getDiscountPercent(planName) * 100).toStringAsFixed(0)}%'),
                      ],
                    ),
                  ),
                  const Divider(thickness: 1),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(
                          'S/${cartProv.totalWithDiscount(planName).toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  // Si no hay plan, sólo subtotal
                  const Divider(thickness: 1),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(
                          'S/${cartProv.subtotal.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    // Lógica de checkout
                  },
                  child: const Text('Finalizar Compra'),
                ),
                const SizedBox(height: 16),
              ],
            ),
    );
  }
}
