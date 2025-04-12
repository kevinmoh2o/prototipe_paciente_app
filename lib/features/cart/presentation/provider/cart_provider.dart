import 'package:flutter/material.dart';
import 'package:paciente_app/features/cart/data/models/cart_item_model.dart';
import 'package:paciente_app/features/medication/data/models/medication_model.dart';

// IMPORTA EL AppointmentModel desde el calendar_provider
// (usando la ruta real según tu proyecto)
import 'package:paciente_app/features/menu_calendar/presentation/provider/calendar_provider.dart' show AppointmentModel;

class CartProvider extends ChangeNotifier {
  // ─────────────────────────────────────────────────────────────
  // MEDICAMENTOS
  final List<CartItemModel> _items = [];
  List<CartItemModel> get items => _items;

  double get subtotal => _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  int get totalItems => _items.fold(0, (sum, c) => sum + c.quantity);

  int get itemsToal => _items.length + _appointmentItems.length;

  double getDiscountPercent(String? plan) {
    if (plan == "Paquete Integral") return 0.10;
    if (plan == "Plan Básico") return 0.05;
    return 0.0;
  }

  double totalWithDiscount(String? plan) {
    final discount = getDiscountPercent(plan);
    return subtotal * (1 - discount);
  }

  void addToCart(MedicationModel med, int quantity) {
    final idx = _items.indexWhere((c) => c.medication.id == med.id);
    if (idx >= 0) {
      _items[idx].quantity += quantity;
    } else {
      _items.add(CartItemModel(medication: med, quantity: quantity));
    }
    notifyListeners();
  }

  bool isInCart(String medicationId) {
    return _items.any((c) => c.medication.id == medicationId);
  }

  void removeFromCart(String medicationId) {
    _items.removeWhere((c) => c.medication.id == medicationId);
    notifyListeners();
  }

  void removeItem(CartItemModel item) {
    _items.remove(item);
    notifyListeners();
  }

  // ─────────────────────────────────────────────────────────────
  // CITAS
  final List<AppointmentModel> _appointmentItems = [];
  List<AppointmentModel> get appointmentItems => _appointmentItems;

  // Subtotal de citas
  double get appointmentSubtotal {
    double sum = 0;
    for (var appt in _appointmentItems) {
      sum += appt.fee;
    }
    return sum;
  }

  // Añadir cita al carrito
  void addToCartAppointment(AppointmentModel appt) {
    final exist = _appointmentItems.any((a) => a.id == appt.id);

    // Evitamos duplicar la cita y solo si no está pagada
    if (!exist && !appt.isPaid) {
      _appointmentItems.add(appt);
      notifyListeners();
    }
  }

  void removeAppointmentFromCart(String appointmentId) {
    _appointmentItems.removeWhere((a) => a.id == appointmentId);
    notifyListeners();
  }

  bool isAppointmentInCart(String appointmentId) {
    return _appointmentItems.any((a) => a.id == appointmentId);
  }

  void payAppointment(String appointmentId) {
    final idx = _appointmentItems.indexWhere((a) => a.id == appointmentId);
    if (idx != -1) {
      _appointmentItems[idx].isPaid = true;
      _appointmentItems.removeAt(idx);
      notifyListeners();
    }
  }

  // ─────────────────────────────────────────────────────────────
  // LIMPIAR TODO
  void clearCart() {
    _items.clear();
    _appointmentItems.clear();
    notifyListeners();
  }

  // TOTAL (medicamentos + citas)
  double get grandTotal => subtotal + appointmentSubtotal;
}
