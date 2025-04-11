import 'package:flutter/material.dart';
import 'package:paciente_app/core/data/models/comment_model.dart';
import 'package:paciente_app/core/data/models/grupo_post_model.dart';
import 'package:paciente_app/core/data/models/recommendation_model.dart';

class EntrenadorInfo {
  final String name;
  final double rating;
  final String imageAsset;
  bool isOnline;

  EntrenadorInfo({
    required this.name,
    required this.rating,
    required this.imageAsset,
    this.isOnline = true,
  });
}

class AptitudProvider extends ChangeNotifier {
  // Respuestas de la evaluación de rutina
  final Map<String, dynamic> _evaluationAnswers = {};
  Map<String, dynamic> get evaluationAnswers => _evaluationAnswers;

  void setEvaluationAnswer(String questionId, dynamic answer) {
    _evaluationAnswers[questionId] = answer;
    notifyListeners();
  }

  // Lista de entrenadores
  final List<EntrenadorInfo> _entrenadores = [
    EntrenadorInfo(name: "Andrea Ramírez", rating: 4.8, imageAsset: "assets/images/doctor_female_2.png", isOnline: true),
    EntrenadorInfo(name: "José Guerrero", rating: 4.6, imageAsset: "assets/images/doctor_male_1.png", isOnline: true),
    EntrenadorInfo(name: "Mariana Tovar", rating: 4.7, imageAsset: "assets/images/doctor_female_1.png", isOnline: false),
  ];
  List<EntrenadorInfo> get entrenadores => _entrenadores;

  // Lista de rutinas
  final List<String> _rutinas = [
    "Rutina de estiramientos suaves (15 min)",
    "Ejercicios de respiración y relajación",
    "Caminata suave de 20 minutos",
    "Fortalecimiento de piernas y brazos con banda elástica",
  ];

  // En tu Provider o en un lugar central, creas la lista:
  final List<RecommendationModel> miListaDeRutinas = [
    RecommendationModel(
      title: "Rutina de estiramientos suaves (15 min)",
      shortDescription: "Ejercicios de estiramiento para relajar músculos.",
      targetDiagnoses: ["Cáncer de huesos", "Cáncer de mama"],
      resources: [
        ResourceModel(
          type: ResourceType.text,
          content: "Empieza con un calentamiento básico de cuello, hombros y brazos durante 5 minutos...",
        ),
        // Podrías agregar imágenes o videos en la lista
      ],
    ),
    RecommendationModel(
      title: "Ejercicios de respiración y relajación",
      shortDescription: "Técnicas de mindfulness y respiración profunda.",
      resources: [
        ResourceModel(
          type: ResourceType.audio,
          content: "assets/audios/relax.mp3", // Por ejemplo
        ),
        ResourceModel(
          type: ResourceType.text,
          content: "1) Siéntate en posición cómoda.\n 2) Cierra los ojos.\n 3) Inhala lentamente por la nariz...",
        ),
      ],
    ),
    // ... y así para cada rutina
  ];

  List<String> get rutinas => _rutinas;

  final List<GrupoPost> _posts = [
    // Ajusta los textos con un tono más motivador
    GrupoPost(
      author: "Carlos S.",
      content: "¡Hoy logré caminar 30 minutos sin agotarme! Me siento orgulloso de mi progreso.",
      reactionCounts: {
        "like": 2,
        "love": 3,
        "haha": 0,
        "wow": 0,
        "sad": 0,
      },
      comments: [
        Comment(author: "Ana Q.", content: "¡Felicidades, Carlos! ¡Sigue así!"),
      ],
    ),
    GrupoPost(
      author: "Ana Q.",
      content: "Les comparto un video con ejercicios de respiración que me han dado mucha paz y energía.",
      reactionCounts: {
        "like": 1,
        "love": 5,
        "haha": 0,
        "wow": 0,
        "sad": 0,
      },
      comments: [],
    ),
    GrupoPost(
      author: "Luis R.",
      content: "Inicié una nueva rutina de ejercicios suaves en casa. Es increíble sentir el cuerpo más activo.",
      reactionCounts: {
        "like": 0,
        "love": 0,
        "haha": 0,
        "wow": 0,
        "sad": 0,
      },
      comments: [],
    ),
    // Más posts...
  ];

  List<GrupoPost> get posts => _posts;

  /// Añadir comentario a una publicación
  void addCommentToPost(int index, String commentText) {
    if (index < 0 || index >= _posts.length) return;
    _posts[index].addComment(
      Comment(author: "Tú", content: commentText),
    );
    notifyListeners();
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

  /// Reaccionar a un comentario en un post
  void reactToComment(int postIndex, int commentIndex) {
    if (postIndex < 0 || postIndex >= _posts.length) return;
    final comments = _posts[postIndex].comments;
    if (commentIndex < 0 || commentIndex >= comments.length) return;
    comments[commentIndex].react();
    notifyListeners();
  }

  // ====== NUEVO/EDITADO EN aptitud_provider.dart (o similar) ======

  void reactToPost(int index, String reactionType) {
    if (index < 0 || index >= _posts.length) return;
    _posts[index].react(reactionType);
    notifyListeners();
  }

// (Opcional) Si quieres conservar el método anterior sin romper llamadas existentes:
  void reactToPostDefault(int index) {
    reactToPost(index, "like");
  }
}
