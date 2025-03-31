// lib/features/medication/data/models/medication_model.dart
class MedicationModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final int stock; // Stock disponible
  final List<String> presentation; // List of available presentations
  final String pharmacy; // Pharmacy where the medication is available
  final double discountPercentage; // Discount percentage, pero se aplica sólo si el plan es "Paquete Integral"

  MedicationModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.stock,
    required this.presentation,
    required this.pharmacy,
    required this.discountPercentage,
  });

  bool get isAvailable => stock > 0;
}
