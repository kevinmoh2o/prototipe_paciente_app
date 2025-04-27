// lib/features/cart/presentation/provider/cart_provider.dart
import 'package:flutter/material.dart';
import 'package:paciente_app/core/data/models/plan_data_model.dart';
import 'package:paciente_app/features/cart/data/models/cart_item_model.dart';
import 'package:paciente_app/features/medication/data/models/medication_model.dart';
import 'package:paciente_app/features/menu_calendar/presentation/provider/calendar_provider.dart' show AppointmentModel;

class CartProvider extends ChangeNotifier {
  // ────────────────────────────────────────── MEDICAMENTOS
  final List<CartItemModel> _items = [];
  List<CartItemModel> get items {
    print('CartProvider.items getter called, items: $_items');
    return _items;
  }

  double get subtotal {
    final value = _items.fold(0.0, (sum, item) => sum + item.totalPrice);
    print('CartProvider.subtotal calculated: $value');
    return value;
  }

  // ────────────────────────────────────────── PLANES
  final List<PlanData> _planItems = [];
  List<PlanData> get planItems {
    print('CartProvider.planItems getter called, planItems: $_planItems');
    return _planItems;
  }

  double get planSubtotal {
    final value = _planItems.fold(0.0, (s, p) => s + p.price);
    print('CartProvider.planSubtotal calculated: $value');
    return value;
  }

  // ────────────────────────────────────────── CITAS
  final List<AppointmentModel> _appointmentItems = [];
  List<AppointmentModel> get appointmentItems {
    print('CartProvider.appointmentItems getter called, appointmentItems: $_appointmentItems');
    return _appointmentItems;
  }

  double get appointmentSubtotal {
    final value = _appointmentItems.fold(0.0, (s, a) => s + a.fee);
    print('CartProvider.appointmentSubtotal calculated: $value');
    return value;
  }

  //  MANTENGO tu propiedad original (con el mismo typo)  ▼
  int get itemsToal {
    final count = _items.length + _appointmentItems.length + _planItems.length;
    print('CartProvider.itemsToal calculated (typo): $count');
    return count;
  }

  //  Propiedad alternativa con conteo detallado
  int get totalItems {
    final count = _items.fold(0, (s, c) => s + c.quantity) + _planItems.length + _appointmentItems.length;
    print('CartProvider.totalItems calculated: $count');
    return count;
  }

  // ──────────────────────────── DESCUENTOS (solo medicamentos)
  double getDiscountPercent(String? plan) {
    print('CartProvider.getDiscountPercent called with plan: $plan');
    if (plan == 'Paquete Integral') {
      print(' -> discount: 0.10');
      return 0.10;
    }
    if (plan == 'Plan Básico') {
      print(' -> discount: 0.05');
      return 0.05;
    }
    print(' -> discount: 0.0');
    return 0.0;
  }

  double totalWithDiscount(String? plan) {
    print('CartProvider.totalWithDiscount called with plan: $plan');
    final discount = getDiscountPercent(plan);
    final total = subtotal * (1 - discount);
    print(' -> totalWithDiscount: $total');
    return total;
  }

  // ──────────────────────────── MÉTODOS MEDICAMENTOS
  void addToCart(MedicationModel med, int quantity) {
    print('CartProvider.addToCart called with medicationId=${med.id}, quantity=$quantity');
    final idx = _items.indexWhere((c) => c.medication.id == med.id);
    if (idx >= 0) {
      _items[idx].quantity += quantity;
      print(' -> updated existing item quantity to ${_items[idx].quantity}');
    } else {
      _items.add(CartItemModel(medication: med, quantity: quantity));
      print(' -> added new CartItemModel: ${_items.last}');
    }
    notifyListeners();
    print(' -> listeners notified after addToCart');
  }

  bool isInCart(String medicationId) {
    final exists = _items.any((c) => c.medication.id == medicationId);
    print('CartProvider.isInCart called with medicationId=$medicationId -> $exists');
    return exists;
  }

  void removeFromCart(String medicationId) {
    print('CartProvider.removeFromCart called with medicationId=$medicationId');
    _items.removeWhere((c) => c.medication.id == medicationId);
    notifyListeners();
    print(' -> listeners notified after removeFromCart');
  }

  void removeItem(CartItemModel item) {
    print('CartProvider.removeItem called with item=$item');
    _items.remove(item);
    notifyListeners();
    print(' -> listeners notified after removeItem');
  }

  // ──────────────────────────── MÉTODOS PLANES
  void addPlan(PlanData plan) {
    print('CartProvider.addPlan called with plan.title=${plan.title}');
    if (!_planItems.any((p) => p.title == plan.title)) {
      _planItems.add(plan);
      notifyListeners();
      print(' -> plan added and listeners notified');
    } else {
      print(' -> plan already in cart, no action taken');
    }
  }

  void removePlan(String planTitle) {
    print('CartProvider.removePlan called with planTitle=$planTitle');
    _planItems.removeWhere((p) => p.title == planTitle);
    notifyListeners();
    print(' -> listeners notified after removePlan');
  }

  bool isPlanInCart(String planTitle) {
    final exists = _planItems.any((p) => p.title == planTitle);
    print('CartProvider.isPlanInCart called with planTitle=$planTitle -> $exists');
    return exists;
  }

  // ──────────────────────────── MÉTODOS CITAS
  void addToCartAppointment(AppointmentModel appt) {
    print('CartProvider.addToCartAppointment called with appointmentId=${appt.id}, isPaid=${appt.isPaid}');
    final exist = _appointmentItems.any((a) => a.id == appt.id);
    if (!exist && !appt.isPaid) {
      _appointmentItems.add(appt);
      notifyListeners();
      print(' -> appointment added and listeners notified');
    } else {
      print(' -> appointment not added (already exists or isPaid)');
    }
  }

  void removeAppointmentFromCart(String appointmentId) {
    print('CartProvider.removeAppointmentFromCart called with appointmentId=$appointmentId');
    _appointmentItems.removeWhere((a) => a.id == appointmentId);
    notifyListeners();
    print(' -> listeners notified after removeAppointmentFromCart');
  }

  bool isAppointmentInCart(String appointmentId) {
    final exists = _appointmentItems.any((a) => a.id == appointmentId);
    print('CartProvider.isAppointmentInCart called with appointmentId=$appointmentId -> $exists');
    return exists;
  }

  void payAppointment(String appointmentId) {
    print('CartProvider.payAppointment called with appointmentId=$appointmentId');
    final idx = _appointmentItems.indexWhere((a) => a.id == appointmentId);
    if (idx != -1) {
      _appointmentItems[idx].isPaid = true;
      _appointmentItems.removeAt(idx);
      notifyListeners();
      print(' -> appointment marked paid, removed from cart, listeners notified');
    } else {
      print(' -> appointment not found, no action');
    }
  }

  // ──────────────────────────── LIMPIAR TODO
  void clearCart() {
    print('CartProvider.clearCart called, clearing all items');
    _items.clear();
    _appointmentItems.clear();
    _planItems.clear();
    notifyListeners();
    print(' -> all items cleared and listeners notified');
  }

  // ──────────────────────────── TOTAL GENERAL
  double get grandTotal {
    final value = subtotal + appointmentSubtotal + planSubtotal;
    print('CartProvider.grandTotal calculated: $value');
    return value;
  }
}
