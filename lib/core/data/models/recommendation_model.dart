/// Un recurso podría ser texto, imagen, audio, video, etc.
enum ResourceType {
  text,
  image,
  video,
  audio,
}

/// Estructura de cada recurso que se mostrará en el detalle.
class ResourceModel {
  final ResourceType type;
  final String content;
  // 'content' podría ser la ruta de un asset (para imagen, audio, video)
  // o texto directo (para ResourceType.text)

  ResourceModel({
    required this.type,
    required this.content,
  });
}

/// Modelo principal de la recomendación.
class RecommendationModel {
  final String title;
  final String shortDescription;

  /// Lista de diagnósticos a los que aplica. Ej: ["Cáncer de huesos", "Cáncer de mama"].
  /// Si está vacío, significa que aplica a todos.
  final List<String> targetDiagnoses;

  /// Recursos que se muestran cuando se accede al detalle.
  final List<ResourceModel> resources;

  RecommendationModel({
    required this.title,
    required this.shortDescription,
    required this.resources,
    this.targetDiagnoses = const [],
  });
}
