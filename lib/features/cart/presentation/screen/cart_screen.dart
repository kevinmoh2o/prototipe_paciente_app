// lib/features/cart/presentation/screen/cart_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:paciente_app/features/cart/presentation/provider/cart_provider.dart';
import 'package:paciente_app/features/create_account/presentation/provider/patient_provider.dart';
import 'package:paciente_app/features/cart/data/models/cart_item_model.dart';

// Importamos nuestro Model y Service
import 'package:paciente_app/features/cart/data/models/payment_method_model.dart';
import 'package:paciente_app/features/cart/data/services/payment_service.dart';

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
        appBar: AppBar(
          title: const Text("Carrito"),
          backgroundColor: const Color(0xFF5B6BF5),
        ),
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
      appBar: AppBar(
        title: const Text("Carrito"),
        backgroundColor: const Color(0xFF5B6BF5),
      ),
      body: Column(
        children: [
          // Lista de items
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
          // Total
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
          // Botón Finalizar
          ElevatedButton(
            onPressed: () => _onCheckout(context, total),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5B6BF5),
              foregroundColor: Colors.white,
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

  void _onCheckout(BuildContext context, double total) {
    // Obtenemos la lista de PaymentMethods desde la Service
    final paymentMethods = PaymentService.getPaymentMethods();

    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (ctx) {
          String? selectedMethod;

          return StatefulBuilder(builder: (stateCtx, setState) {
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

                  // Lista horizontal de métodos
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
                          onTap: () {
                            setState(() => selectedMethod = pm.name);
                          },
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
                            _showPaymentSuccess(context, selectedMethod!, total);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5B6BF5),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    ),
                    child: const Text("Pagar"),
                  )
                ],
              ),
            );
          });
        });
  }

  void _showPaymentSuccess(BuildContext context, String method, double total) {
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
                  // Podrías vaciar el carrito o redirigir a otra pantalla
                },
                child: const Text("OK"),
              )
            ],
          );
        });
  }
}

// Widget para cada ítem del carrito
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
            Text('S/ ${totalItemPrice.toStringAsFixed(2)}'),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                cartProv.removeItem(cartItem);
              },
            )
          ],
        ),
      ),
    );
  }
}
