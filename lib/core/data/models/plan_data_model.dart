class PlanData {
  final String title;
  final double price;
  final double? discount; // 0.23 => 23%
  final String description;
  final List<String> benefits;

  const PlanData({
    required this.title,
    required this.price,
    this.discount,
    required this.description,
    required this.benefits,
  });
}
