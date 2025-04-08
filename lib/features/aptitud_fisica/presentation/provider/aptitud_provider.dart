// lib/features/aptitud_fisica/presentation/provider/aptitud_provider.dart

import 'package:flutter/material.dart';

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

class AptitudPost {
  final String author;
  final String content;
  int reactions;
  int comments;

  AptitudPost({
    required this.author,
    required this.content,
    this.reactions = 0,
    this.comments = 0,
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
  List<String> get rutinas => _rutinas;

  // Feed de grupos de aptitud
  final List<AptitudPost> _posts = [
    AptitudPost(author: "Carlos S.", content: "Hoy logré caminar 30 min sin agotarme ¡feliz!", reactions: 10, comments: 2),
    AptitudPost(author: "Ana Q.", content: "Comparto un video con ejercicios de respiración que me ayudaron mucho", reactions: 5, comments: 1),
    AptitudPost(author: "Luis R.", content: "He comenzado un nuevo régimen de ejercicios en casa. ¡Emocionado!", reactions: 12, comments: 3),
    AptitudPost(author: "Marta G.", content: "Hoy alcancé mi objetivo de beber 2 litros de agua, ¡me siento genial!", reactions: 8, comments: 4),
    AptitudPost(author: "Jorge M.", content: "Logré hacer mi primera clase de yoga, fue desafiante pero increíble", reactions: 15, comments: 5),
    AptitudPost(
        author: "Sofía P.",
        content: "Realicé una caminata en la naturaleza y fue muy relajante, recomiendo a todos hacerlo",
        reactions: 20,
        comments: 7),
  ];
  List<AptitudPost> get posts => _posts;

  void reactToPost(int index) {
    if (index < 0 || index >= _posts.length) return;
    _posts[index].reactions++;
    notifyListeners();
  }

  void commentOnPost(int index) {
    if (index < 0 || index >= _posts.length) return;
    _posts[index].comments++;
    notifyListeners();
  }
}
