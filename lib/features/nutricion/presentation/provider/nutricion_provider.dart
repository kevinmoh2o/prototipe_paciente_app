import 'package:flutter/material.dart';
import 'package:paciente_app/core/data/models/comment_model.dart';
import 'package:paciente_app/core/data/models/grupo_post_model.dart';
import 'package:paciente_app/core/data/models/recommendation_model.dart';

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
  final List<RecommendationModel> recetasRecommendations = [
    RecommendationModel(
      title: "Ensalada de Quinoa con verduras",
      shortDescription: "Ensalada fresca y nutritiva con quinoa, verduras y un toque cítrico.",
      targetDiagnoses: [],
      resources: [
        ResourceModel(
          type: ResourceType.image,
          content: "images/ensalada_quinoa.jpg",
        ),
        ResourceModel(
          type: ResourceType.text,
          content: "Ingredientes:\n"
              "• 1 taza de quinoa\n"
              "• 2 tazas de agua\n"
              "• 1 tomate grande picado\n"
              "• 1 pepino mediano cortado en cubos\n"
              "• 1 zanahoria rallada\n"
              "• Hojas de espinaca o lechuga al gusto\n"
              "• Jugo de 1 limón\n"
              "• Aceite de oliva, sal y pimienta al gusto\n\n"
              "Preparación:\n"
              "1. Enjuaga la quinoa con agua fría para eliminar la saponina, que podría dar un sabor amargo.\n"
              "2. Cocina la quinoa con 2 tazas de agua y una pizca de sal a fuego lento durante 15 minutos o hasta que se absorba el agua.\n"
              "3. Deja enfriar la quinoa y mézclala en un bol grande con el tomate, pepino, zanahoria y las hojas verdes.\n"
              "4. Añade el jugo de limón y el aceite de oliva, y sazona con sal y pimienta al gusto.\n\n"
              "¡Disfruta de una ensalada fresca y nutritiva!",
        ),
      ],
    ),
    RecommendationModel(
      title: "Sopa de vegetales con pollo",
      shortDescription: "Sopa reconfortante con vegetales y pollo, ideal para una comida saludable.",
      targetDiagnoses: [],
      resources: [
        ResourceModel(
          type: ResourceType.image,
          content: "images/sopa_vegetales.jpg",
        ),
        ResourceModel(
          type: ResourceType.text,
          content: "Ingredientes:\n"
              "• 2 pechugas de pollo (sin piel)\n"
              "• 2 zanahorias peladas y cortadas en rodajas\n"
              "• 2 tallos de apio picados\n"
              "• 1 cebolla mediana picada\n"
              "• 2 papas medianas (opcional)\n"
              "• 1 litro de caldo de pollo (casero o envasado)\n"
              "• Sal y pimienta al gusto\n\n"
              "Preparación:\n"
              "1. Calienta una olla grande a fuego medio y agrega un chorrito de aceite.\n"
              "2. Sofríe la cebolla, las zanahorias y el apio hasta que estén ligeramente dorados.\n"
              "3. Agrega las pechugas de pollo y el caldo de pollo.\n"
              "4. Lleva a ebullición y reduce el fuego.\n"
              "5. Cocina durante 15-20 minutos, o hasta que el pollo esté bien cocido.\n"
              "6. Retira las pechugas, desmenúzalas y devuélvelas a la sopa.\n"
              "7. Añade las papas y cocina otros 10-15 minutos, o hasta que estén blandas.\n"
              "8. Ajusta la sal y pimienta según tu preferencia.\n\n"
              "¡Disfruta de una reconfortante sopa de vegetales con pollo!",
        ),
      ],
    ),
    RecommendationModel(
      title: "Batido verde con espinacas y frutas",
      shortDescription: "Batido refrescante lleno de energía y nutrientes, perfecto para el desayuno.",
      targetDiagnoses: [],
      resources: [
        ResourceModel(
          type: ResourceType.image,
          content: "images/batido_verde.jpg", // Imagen de ejemplo
        ),
        ResourceModel(
          type: ResourceType.text,
          content: "Tiempo total: 10 min\n"
              "Preparación: 10 min\n"
              "Porciones: 2\n\n"
              "Ingredientes:\n"
              "• 1 atado de espinacas\n"
              "• 1 manojo de perejil\n"
              "• 1 pepino mediano\n"
              "• 2 tazas de agua\n"
              "• 1 trozo pequeño de jengibre rallado (opcional)\n"
              "• Vinagre de umeboshi u otro sin azúcares (opcional)\n\n"
              "Preparación:\n"
              "1. Lava bien las hojas verdes (espinacas, perejil) y el pepino.\n"
              "2. Coloca en la licuadora las hojas verdes con el agua y el jengibre rallado.\n"
              "3. Licúa primero las hojas verdes y el agua para que quede todo bien triturado.\n"
              "4. Agrega el pepino (y si gustas, el vinagre de umeboshi) y continúa licuando hasta obtener una textura homogénea.\n"
              "5. Ajusta la cantidad de agua para que quede más o menos espeso, según tu preferencia.\n\n"
              "¡Disfruta de un batido nutritivo y refrescante!",
        ),
      ],
    ),
    RecommendationModel(
      title: "Pescado al horno con especias",
      shortDescription: "Pescado al horno preparado con hierbas y especias, una opción ligera y deliciosa.",
      targetDiagnoses: [],
      resources: [
        ResourceModel(
          type: ResourceType.image,
          content: "images/pescado_al_horno.jpg", // Imagen de ejemplo
        ),
        ResourceModel(
          type: ResourceType.text,
          content: "Plato: Pescados\n"
              "Cocina: Saludable\n"
              "Keyword: al horno\n\n"
              "Tiempo de preparación: 45 min\n"
              "Tiempo de cocción: 30 min\n"
              "Tiempo total: 1 hora 15 min\n"
              "Raciones: 2\n"
              "Calorías: 95 kcal\n"
              "Autor: María Alejandra Gómez\n\n"
              "Ingredientes:\n"
              "• 1/2 kg de filete de merluza\n"
              "• 1 limón\n"
              "• Sal al gusto\n"
              "• Adobo al gusto\n"
              "• Pimienta negra al gusto\n"
              "• 1 cebolla morada\n"
              "• 4 papas\n"
              "• 3 pimientos rojos\n"
              "• 4 dientes de ajo\n"
              "• 15 tomates cherry\n"
              "• 1 rama de orégano fresco\n"
              "• 150 ml de aceite de oliva\n"
              "• 150 ml de vino blanco\n\n"
              "Elaboración paso a paso:\n\n"
              "1. **Sazonar el filete:**\n"
              "   - Limpia el pescado y ponlo en un bol. Tritura o licua los ajos con la mitad del aceite, el vino blanco, un poco de sal, adobo y pimienta.\n"
              "   - Vierte la mitad de esta mezcla sobre el filete y exprime la mitad del limón.\n\n"
              "2. **Preparar las papas:**\n"
              "   - Precalienta el horno a 180 °C.\n"
              "   - Lava, pela y corta las papas en rodajas de aproximadamente 1 cm. Colócalas en una bandeja para horno ligeramente engrasada.\n"
              "   - Espolvorea sal y pimienta sobre las papas.\n"
              "   - Lava y corta los pimientos y la cebolla en tiras, y colócalos sobre las papas.\n"
              "   - Agrega unas cucharadas de la mezcla de ajo, aceite y vino blanco.\n"
              "   - Limpia los tomates cherry y colócalos sobre las verduras.\n"
              "   - Hornea durante 30 min, o hasta que las papas se vean suaves y doradas.\n\n"
              "3. **Sellar el filete:**\n"
              "   - Mientras las papas se hornean, calienta una sartén con una cucharada de aceite de oliva.\n"
              "   - Cocina el filete de merluza aproximadamente 3 min por cada lado para sellar los sabores.\n\n"
              "4. **Cocción al horno:**\n"
              "   - Cuando las papas estén suaves, retira la bandeja del horno y coloca encima el filete sellado.\n"
              "   - Espolvorea orégano fresco y regresa la bandeja al horno por 20-25 min más.\n\n"
              "5. **Emplatado:**\n"
              "   - Sirve en un plato llano una cama de papas y vegetales.\n"
              "   - Encima coloca el filete de merluza, y decora con rodajas de limón.\n\n"
              "¡Listo! Disfruta de un pescado al horno jugoso y lleno de sabor.",
        ),
      ],
    )
  ];

  List<String> get recetas => _recetas;
  final List<GrupoPost> _posts = [
    GrupoPost(
      author: "Carla P.",
      content: "Comparto mi desayuno saludable: avena con frutas y un té de hierbas. ¡Me siento con más energía!",
      reactionCounts: {
        "like": 0,
        "love": 0,
        "haha": 0,
        "wow": 0,
        "sad": 0,
      },
      comments: [
        Comment(author: "Lucía M.", content: "¡Suena delicioso! ¿Qué frutas le pusiste?"),
      ],
    ),
    GrupoPost(
      author: "Lucía M.",
      content: "¿Algún consejo para consumir más verduras sin forzarme demasiado?",
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
      author: "David L.",
      content: "Estoy probando un ayuno intermitente suave. ¿Alguien más ha sentido mejoras?",
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

  /* void reactToPost(int index) {
    if (index < 0 || index >= _posts.length) return;
    _posts[index].react();
    notifyListeners();
  } */

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
