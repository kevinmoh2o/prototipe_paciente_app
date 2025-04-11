/// lib/core/data/models/comment_model.dart

class Comment {
  final String author;
  final String content;
  int reactions;
  final DateTime createdAt;

  Comment({
    required this.author,
    required this.content,
    this.reactions = 0,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  void react() {
    reactions++;
  }
}
