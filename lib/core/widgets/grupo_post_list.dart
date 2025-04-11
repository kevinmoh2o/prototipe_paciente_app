import 'package:flutter/material.dart';
import 'package:paciente_app/core/data/models/grupo_post_model.dart';

class GrupoPostList extends StatelessWidget {
  final List<GrupoPost> posts;
  final void Function(int index) onReact;
  final void Function(int index) onComment;
  final Color? color;

  const GrupoPostList({
    super.key,
    required this.posts,
    required this.onReact,
    required this.onComment,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: posts.length,
      itemBuilder: (ctx, i) {
        final p = posts[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(p.author, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(p.content, style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.thumb_up, color: Colors.blue),
                    onPressed: () => onReact(i),
                  ),
                  Text("${p.reactionCounts.length}"),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(Icons.comment, color: Colors.grey),
                    onPressed: () => onComment(i),
                  ),
                  Text("${p.comments}"),
                ],
              ),
              const Divider(),
              Row(
                children: const [
                  CircleAvatar(radius: 14, child: Icon(Icons.person, size: 16)),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Escribe un comentario...",
                        border: OutlineInputBorder(),
                        isDense: true,
                        contentPadding: EdgeInsets.all(8),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
