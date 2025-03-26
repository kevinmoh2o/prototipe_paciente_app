class MedicationModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final bool isAvailable; // en stock
  final List<String> presentation; // List of available presentations
  final String pharmacy; // Pharmacy where the medication is available
  final double discountPercentage; // Discount percentage for subscriptions or plans

  MedicationModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isAvailable = true,
    required this.presentation,
    required this.pharmacy,
    required this.discountPercentage,
  });
}
