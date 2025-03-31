// lib/features/cart/data/models/cart_item_model.dart
import 'package:paciente_app/features/medication/data/models/medication_model.dart';

class CartItemModel {
  final MedicationModel medication;
  int quantity;

  CartItemModel({
    required this.medication,
    this.quantity = 1,
  });

  double get totalPrice => medication.price * quantity;
}
