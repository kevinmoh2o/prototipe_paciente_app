class PsicologiaOptionModel {
  final String title;
  final String description;
  final String iconPath; // Ruta de ícono (asset)
  final bool isFavorite; // Para mostrar el corazoncito

  PsicologiaOptionModel({
    required this.title,
    required this.description,
    required this.iconPath,
    this.isFavorite = false,
  });
}
