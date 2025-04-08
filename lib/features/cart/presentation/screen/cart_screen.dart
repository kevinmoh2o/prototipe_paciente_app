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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.remove_shopping_cart_outlined,
              color: Colors.grey,
              size: 50,
            ),
            Center(child: Text('Carrito vacío')),
          ],
        ),
      );
    }

    double total = 0.0;
    for (final item in items) {
      final hasPlanDiscount = (plan == "Paquete Integral") && (item.medication.discountPercentage > 0);
      final discountFactor = hasPlanDiscount ? (1 - (item.medication.discountPercentage / 100)) : 1.0;
      final priceWithPlan = item.medication.price * discountFactor * item.quantity;
      total += priceWithPlan;
    }

    return Scaffold(
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
              // Lógica de checkout
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
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

  const _CartItemTile({
    Key? key,
    required this.cartItem,
    this.plan,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProv = context.read<CartProvider>();

    final hasPlanDiscount = (plan == "Paquete Integral") && (cartItem.medication.discountPercentage > 0);
    final discountFactor = hasPlanDiscount ? (1 - (cartItem.medication.discountPercentage / 100)) : 1.0;
    final priceWithDiscount = cartItem.medication.price * discountFactor;
    final totalItemPrice = priceWithDiscount * cartItem.quantity;

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
      trailing: SizedBox(
        width: 120,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Mostrar total del item
            Text('S/ ${totalItemPrice.toStringAsFixed(2)}'),
            const SizedBox(width: 8),
            // Botón eliminar
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                // Remover el item del cart
                cartProv.removeItem(cartItem);
              },
            ),
          ],
        ),
      ),
    );
  }
}
