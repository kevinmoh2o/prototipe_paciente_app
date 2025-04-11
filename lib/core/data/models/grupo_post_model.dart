// ====== NUEVO/EDITADO EN grupo_post_model.dart ======

import 'package:paciente_app/core/data/models/comment_model.dart';

class GrupoPost {
  final String author;
  final String content;

  // ────────── SE ELIMINA o IGNORA el "int reactions;"
  // int reactions;

  // ────────── NUEVO: cada tipo de reacción con su conteo
  Map<String, int> reactionCounts = {
    "like": 0,
    "love": 0,
    "haha": 0,
    "wow": 0,
    "sad": 0,
  };

  final List<Comment> comments;

  GrupoPost({
    required this.author,
    required this.content,
    required this.reactionCounts,
    // Quita el "this.reactions" de tu constructor
    List<Comment>? comments,
  }) : comments = comments ?? [];

  // ────────── NUEVO: método para reaccionar con un tipo específico
  void react(String reactionType) {
    if (reactionCounts.containsKey(reactionType)) {
      reactionCounts[reactionType] = reactionCounts[reactionType]! + 1;
    }
  }

  // ────────── NUEVO: total de reacciones (suma)
  int get totalReactions => reactionCounts.values.fold(0, (sum, val) => sum + val);

  // ────────── NUEVO: reacciones usadas (conteo > 0) en orden
  List<String> getUsedReactionsInOrder() {
    // Orden que queremos mostrar
    const priorityOrder = ["like", "love", "haha", "wow", "sad"];
    return priorityOrder.where((type) => reactionCounts[type]! > 0).toList();
  }

  void addComment(Comment newComment) {
    comments.add(newComment);
  }
}
