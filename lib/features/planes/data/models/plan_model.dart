class PlanModel {
  final String title; // "Paquete Integral"
  final double price; // 175.0
  final String description; // "Acceso a todos los paquetes..."
  final double? discount; // 0.23 => "Ahorre 23%"
  final List<String> benefits; // "Acceso a Telemedicina", etc.

  PlanModel({
    required this.title,
    required this.price,
    required this.description,
    this.discount,
    required this.benefits,
  });
}
