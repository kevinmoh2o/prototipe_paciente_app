// lib/features/psicologico_espiritual/data/model/psicologia_option_model.dart

class PsicologiaOptionModel {
  final String id;
  final String title;
  final String description;
  final String imageAsset;
  bool isFavorite; // Manejo de "favorito"

  PsicologiaOptionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageAsset,
    this.isFavorite = false,
  });
}
