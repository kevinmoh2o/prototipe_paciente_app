// lib/features/nutricion/presentation/provider/nutricion_provider.dart

import 'package:flutter/material.dart';

class NutriDoctor {
  final String name;
  final double rating;
  final String imageAsset;
  bool isOnline;

  NutriDoctor({
    required this.name,
    required this.rating,
    required this.imageAsset,
    this.isOnline = true,
  });
}

class NutriPost {
  final String author;
  final String content;
  int reactions;
  int comments;

  NutriPost({
    required this.author,
    required this.content,
    this.reactions = 0,
    this.comments = 0,
  });
}

class NutricionProvider extends ChangeNotifier {
  // Evaluación nutricional
  final Map<String, dynamic> _evaluationAnswers = {};
  Map<String, dynamic> get evaluationAnswers => _evaluationAnswers;

  void setEvalAnswer(String questionId, dynamic answer) {
    _evaluationAnswers[questionId] = answer;
    notifyListeners();
  }

  // Lista de doctores/nutriólogos
  final List<NutriDoctor> _nutriDoctors = [
    NutriDoctor(name: "Dra. Laura Díaz", rating: 4.6, imageAsset: "assets/images/doctor_female_1.png", isOnline: true),
    NutriDoctor(name: "Dr. Marcos Rivera", rating: 4.8, imageAsset: "assets/images/doctor_male_1.png", isOnline: true),
    NutriDoctor(name: "Dra. Elena Rojas", rating: 4.5, imageAsset: "assets/images/doctor_female_2.png", isOnline: false),
  ];
  List<NutriDoctor> get nutriDoctors => _nutriDoctors;

  // Lista de recetas
  final List<String> _recetas = [
    "Ensalada de Quinoa con verduras",
    "Sopa de vegetales con pollo",
    "Batido verde con espinacas y frutas",
    "Pescado al horno con especias",
  ];
  List<String> get recetas => _recetas;

  // Feed de grupos de nutrición
  final List<NutriPost> _posts = [
    NutriPost(author: "Carla P.", content: "Comparto mi receta saludable para el desayuno: avena con frutas.", reactions: 10, comments: 2),
    NutriPost(author: "Lucía M.", content: "¿Algún tip para comer verduras si no me gustan?", reactions: 8, comments: 3),
    NutriPost(author: "David L.", content: "Estoy probando el ayuno intermitente. ¿Alguien más lo ha hecho?", reactions: 15, comments: 4),
    NutriPost(
        author: "Sofía R.",
        content: "Descubrí una receta deliciosa de batido verde para desintoxicar. ¡Totalmente recomendada!",
        reactions: 12,
        comments: 5),
    NutriPost(
        author: "Fernando J.",
        content: "Hoy comí quinoa con aguacate y tomate, una opción súper saludable para el almuerzo.",
        reactions: 18,
        comments: 6),
    NutriPost(
        author: "Ana L.", content: "¿Cómo puedo reemplazar el azúcar en mis postres? Busco alternativas más saludables.", reactions: 9, comments: 2),
  ];

  List<NutriPost> get posts => _posts;

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
