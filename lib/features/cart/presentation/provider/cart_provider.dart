import 'package:flutter/material.dart';
import 'package:paciente_app/features/cart/data/models/cart_item_model.dart';
import 'package:paciente_app/features/medication/data/models/medication_model.dart';
import 'package:paciente_app/features/create_account/presentation/provider/patient_provider.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItemModel> _items = [];

  List<CartItemModel> get items => _items;

  double get subtotal => _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  int get totalItems => _items.fold(0, (sum, c) => sum + c.quantity);

  // Ejemplo: si el plan del paciente da 10% de descuento
  double getDiscountPercent(String? plan) {
    // tu lógica según plan
    if (plan == "Paquete Integral") return 0.10;
    if (plan == "Plan Básico") return 0.05;
    return 0.0;
  }

  double totalWithDiscount(String? plan) {
    final discount = getDiscountPercent(plan);
    return subtotal * (1 - discount);
  }

  // Agrega 'quantity' unidades del medicamento
  void addToCart(MedicationModel med, int quantity) {
    final idx = _items.indexWhere((c) => c.medication.id == med.id);
    if (idx >= 0) {
      _items[idx].quantity += quantity;
    } else {
      _items.add(CartItemModel(medication: med, quantity: quantity));
    }
    notifyListeners();
  }

  // Retorna si el med está en el carrito
  bool isInCart(String medicationId) {
    return _items.any((c) => c.medication.id == medicationId);
  }

  void removeFromCart(String medicationId) {
    _items.removeWhere((c) => c.medication.id == medicationId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  // etc... (actualizar cantidad, etc.)
}
