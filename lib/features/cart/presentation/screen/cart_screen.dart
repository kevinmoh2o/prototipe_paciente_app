// lib/features/cart/presentation/screen/cart_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:paciente_app/features/cart/presentation/provider/cart_provider.dart';
import 'package:paciente_app/features/create_account/presentation/provider/patient_provider.dart';
import 'package:paciente_app/features/cart/data/models/cart_item_model.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProv = context.watch<CartProvider>();
    final patientProv = context.watch<PatientProvider>();
    final items = cartProv.items;
    final plan = patientProv.patient.activePlan;

    if (items.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Carrito de Compras')),
        body: const Center(child: Text('Carrito vacío')),
      );
    }

    double total = 0.0;
    for (final item in items) {
      // Aplica descuento sólo si el plan es "Paquete Integral" y hay discount en el med
      final hasPlanDiscount = (plan == "Paquete Integral") && (item.medication.discountPercentage > 0);
      final discountFactor = hasPlanDiscount ? (1 - (item.medication.discountPercentage / 100)) : 1.0;
      final priceWithPlan = item.medication.price * discountFactor * item.quantity;
      total += priceWithPlan;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Carrito de Compras')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (_, i) {
                final cartItem = items[i];
                return _CartItemTile(cartItem: cartItem, plan: plan);
              },
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
                  'S/ ${total.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              // Lógica de checkout, etc.
            },
            child: const Text('Finalizar Compra'),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// Widget para cada ítem
class _CartItemTile extends StatelessWidget {
  final CartItemModel cartItem;
  final String? plan;
  const _CartItemTile({Key? key, required this.cartItem, this.plan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasPlanDiscount = (plan == "Paquete Integral") && (cartItem.medication.discountPercentage > 0);
    final discountFactor = hasPlanDiscount ? (1 - (cartItem.medication.discountPercentage / 100)) : 1.0;
    final priceWithDiscount = cartItem.medication.price * discountFactor;

    return ListTile(
      leading: Image.asset(
        cartItem.medication.imageUrl,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      ),
      title: Text(cartItem.medication.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasPlanDiscount)
            Text(
              'S/ ${cartItem.medication.price.toStringAsFixed(2)}',
              style: const TextStyle(
                decoration: TextDecoration.lineThrough,
                color: Colors.red,
              ),
            ),
          Text('Precio c/u: S/ ${priceWithDiscount.toStringAsFixed(2)}'),
          Text('Cantidad: ${cartItem.quantity}'),
        ],
      ),
      trailing: Text('Total: S/ ${(priceWithDiscount * cartItem.quantity).toStringAsFixed(2)}'),
    );
  }
}
