import 'package:flutter/material.dart';
import 'package:paciente_app/core/data/models/comment_model.dart';
import 'package:paciente_app/core/data/models/grupo_post_model.dart';
import 'package:paciente_app/core/data/models/recommendation_model.dart';

class PsicologoInfo {
  final String name;
  final double rating;
  final String imageAsset;
  bool isOnline;

  PsicologoInfo({
    required this.name,
    required this.rating,
    required this.imageAsset,
    this.isOnline = true,
  });
}

class PsicologiaProvider extends ChangeNotifier {
  // 1) Cuestionario de Evaluación
  Map<String, dynamic> _evaluationAnswers = {};
  Map<String, dynamic> get evaluationAnswers => _evaluationAnswers;

  void setEvaluationAnswer(String questionId, dynamic answer) {
    _evaluationAnswers[questionId] = answer;
    notifyListeners();
  }

  // 2) Lista de psicólogos para Consulta Psicológica
  final List<PsicologoInfo> _psicologos = [
    PsicologoInfo(name: "Dra. Paula Pérez", rating: 4.7, imageAsset: "assets/images/doctor_female_1.png"),
    PsicologoInfo(name: "Dr. Julio Sánchez", rating: 4.5, imageAsset: "assets/images/doctor_male_1.png"),
    PsicologoInfo(name: "Dra. Karla Torres", rating: 4.8, imageAsset: "assets/images/doctor_female_2.png", isOnline: false),
  ];
  List<PsicologoInfo> get psicologos => _psicologos;

  // Ejemplo: datos
  final List<String> _recursosEspirituales = [
    "Oración matutina para iniciar el día con esperanza.",
    "Lectura motivacional: 'Cada día un paso'.",
    "Audio de meditación guiada.",
  ];

  final List<RecommendationModel> recursosEspiritualesRecommendations = [
    RecommendationModel(
      title: "Oración matutina para iniciar el día con esperanza",
      shortDescription: "Una oración que te llena de esperanza para comenzar el día con fe.",
      targetDiagnoses: [],
      resources: [
        // Recurso de audio para reproducir la oración
        ResourceModel(
          type: ResourceType.audio,
          content: "assets/audios/oracion_matutina.mp3", // Ubicación en assets/audios/
        ),
        // Recurso de texto con la transcripción de la oración (opcional)
        ResourceModel(
          type: ResourceType.text,
          content: "Querido Dios, al iniciar este día, te pido fortaleza, esperanza y la guía necesaria para enfrentar los desafíos. Amén.",
        ),
      ],
    ),
    RecommendationModel(
      title: "Lectura motivacional: 'Cada día un paso'",
      shortDescription: "Una lectura inspiradora para motivarte a avanzar poco a poco.",
      targetDiagnoses: [],
      resources: [
        // Recurso de texto con el contenido motivacional
        ResourceModel(
          type: ResourceType.text,
          content: "Cada día es una nueva oportunidad para crecer, aprender y acercarte a tus metas. Da un paso a la vez y confía en tu capacidad.",
        ),
        // Puedes añadir una imagen ilustrativa opcional
        ResourceModel(
          type: ResourceType.image,
          content: "assets/images/lectura_motivacional.jpg",
        ),
      ],
    ),
    RecommendationModel(
      title: "Audio de meditación guiada",
      shortDescription: "Meditación guiada para ayudarte a relajarte y reconectar con tu interior.",
      targetDiagnoses: [],
      resources: [
        // Recurso de audio para la meditación
        ResourceModel(
          type: ResourceType.audio,
          content: "audios/meditacion_guiada.mp3",
        ),
        // Recurso de texto con instrucciones para la meditación
        ResourceModel(
          type: ResourceType.text,
          content:
              "Encuentra un lugar tranquilo, cierra los ojos y concéntrate en tu respiración. Deja ir las preocupaciones y conecta con tu paz interior.",
        ),
      ],
    ),
  ];

  List<String> get recursosEspirituales => _recursosEspirituales;

  final List<GrupoPost> _posts = [
    GrupoPost(
      author: "María A.",
      content: "Hoy tuve mi primera quimioterapia. Fue duro, pero tengo esperanza y agradezco el apoyo de todos.",
      reactionCounts: {
        "like": 0,
        "love": 0,
        "haha": 0,
        "wow": 0,
        "sad": 0,
      },
      comments: [
        Comment(author: "Carlos G.", content: "¡Ánimo, María! Un día a la vez, aquí estamos para ti."),
      ],
    ),
    GrupoPost(
      author: "Carlos G.",
      content: "Comparto un artículo que me ayudó a manejar la ansiedad durante mis sesiones.",
      reactionCounts: {
        "like": 0,
        "love": 0,
        "haha": 0,
        "wow": 0,
        "sad": 0,
      },
      comments: [],
    ),
    GrupoPost(
      author: "Ana R.",
      content: "Gracias por sus consejos, han sido mi luz en estos momentos difíciles.",
      reactionCounts: {
        "like": 0,
        "love": 0,
        "haha": 0,
        "wow": 0,
        "sad": 0,
      },
      comments: [],
    ),
    // ... (resto de posts que tenías, pero puedes retocar textos si gustas) ...
  ];

  List<GrupoPost> get posts => _posts;

/*   void reactToPost(int index) {
    if (index < 0 || index >= _posts.length) return;
    _posts[index].react();
    notifyListeners();
  }
 */
  void addCommentToPost(int index, String commentText) {
    if (index < 0 || index >= _posts.length) return;
    _posts[index].addComment(
      Comment(author: "Tú", content: commentText),
    );
    notifyListeners();
  }

  void reactToComment(int postIndex, int commentIndex) {
    if (postIndex < 0 || postIndex >= _posts.length) return;
    final comments = _posts[postIndex].comments;
    if (commentIndex < 0 || commentIndex >= comments.length) return;
    comments[commentIndex].react();
    notifyListeners();
  }

  void reactToPost(int index, String reactionType) {
    if (index < 0 || index >= _posts.length) return;
    _posts[index].react(reactionType);
    notifyListeners();
  }

// (Opcional) Si quieres conservar el método anterior sin romper llamadas existentes:
  void reactToPostDefault(int index) {
    reactToPost(index, "like");
  }

  void addPost(String content) {
    final newPost = GrupoPost(
      author: "Tú", // Puedes ajustar el autor según el usuario logueado
      content: content,
      reactionCounts: {
        "like": 0,
        "love": 0,
        "haha": 0,
        "wow": 0,
        "sad": 0,
      },
      comments: [],
    );
    // Inserta el nuevo post al inicio de la lista o al final, según tu preferencia
    _posts.insert(0, newPost);
    notifyListeners();
  }
}
