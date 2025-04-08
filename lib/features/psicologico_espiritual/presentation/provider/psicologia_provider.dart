// lib/features/psicologico_espiritual/presentation/provider/psicologia_provider.dart

import 'package:flutter/material.dart';

// Modelos de ejemplo
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

class PostModel {
  final String author;
  final String content;
  int reactionsCount;
  int commentsCount;

  PostModel({
    required this.author,
    required this.content,
    this.reactionsCount = 0,
    this.commentsCount = 0,
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

  // 4) Feed de Grupos de Apoyo
  final List<PostModel> _posts = [
    // Ejemplos originales
    PostModel(
      author: "María A.",
      content: "Hoy tuve mi primera quimioterapia, fue duro pero me siento con ganas de seguir adelante.",
      commentsCount: 2,
      reactionsCount: 10,
    ),
    PostModel(
      author: "Carlos G.",
      content: "Comparto un artículo que me ayudó a sobrellevar la ansiedad.",
      commentsCount: 1,
      reactionsCount: 4,
    ),
    PostModel(
      author: "Ana R.",
      content: "Gracias por sus palabras de ánimo, me sirvieron mucho en momentos difíciles.",
      reactionsCount: 15,
      commentsCount: 3,
    ),

    // Ejemplos adicionales
    PostModel(
      author: "Lucía P.",
      content: "Hoy tuve una sesión de terapia que me hizo sentir mucho más tranquila, ¡gracias por su apoyo!",
      commentsCount: 5,
      reactionsCount: 18,
    ),
    PostModel(
      author: "Raúl V.",
      content: "Empecé a practicar la meditación diaria y ya noto cómo mi mente se calma más rápido.",
      commentsCount: 3,
      reactionsCount: 12,
    ),
    PostModel(
      author: "Sandra L.",
      content: "A veces, solo necesitamos un poco de tiempo para nosotros mismos, ¡espero que todos encuentren paz hoy!",
      commentsCount: 2,
      reactionsCount: 20,
    ),
    PostModel(
      author: "José F.",
      content: "Recibí una palabra de aliento hoy y fue justo lo que necesitaba para seguir adelante. ¡Gracias!",
      commentsCount: 4,
      reactionsCount: 25,
    ),
    PostModel(
      author: "Natalia M.",
      content: "Estoy aprendiendo a decir 'no' cuando algo no me beneficia, y me siento mucho más fuerte.",
      commentsCount: 3,
      reactionsCount: 30,
    ),
    PostModel(
      author: "Fernando A.",
      content: "Después de una conversación con un amigo, entendí que hay momentos en los que el apoyo externo es crucial.",
      commentsCount: 6,
      reactionsCount: 22,
    ),
  ];

  List<PostModel> get posts => _posts;

  void reactToPost(int index) {
    if (index < 0 || index >= _posts.length) return;
    _posts[index].reactionsCount++;
    notifyListeners();
  }

  void commentOnPost(int index) {
    if (index < 0 || index >= _posts.length) return;
    _posts[index].commentsCount++;
    notifyListeners();
  }

  // Apoyo Espiritual: Podrías manejar una lista de “resources” si gustas.

  // Ejemplo: datos
  final List<String> _recursosEspirituales = [
    "Oración matutina para iniciar el día con esperanza.",
    "Lectura motivacional: 'Cada día un paso'.",
    "Audio de meditación guiada.",
  ];
  List<String> get recursosEspirituales => _recursosEspirituales;
}
