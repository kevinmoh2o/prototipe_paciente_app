class CategoryModel {
  final String title;
  final String iconPath; // Ruta de ícono o asset
  final String? description;

  CategoryModel({
    required this.title,
    required this.iconPath,
    this.description,
  });
}
