// lib/features/psicologico_espiritual/presentation/screen/grupos_apoyo_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:paciente_app/features/psicologico_espiritual/presentation/provider/psicologia_provider.dart';

class GruposApoyoScreen extends StatelessWidget {
  const GruposApoyoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final psyProv = context.watch<PsicologiaProvider>();
    final posts = psyProv.posts;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Grupos de Apoyo"),
        backgroundColor: Colors.blueGrey,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: posts.length,
        itemBuilder: (ctx, i) {
          final post = posts[i];
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
                Text(
                  post.author,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  post.content,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.thumb_up, color: Colors.blue),
                          onPressed: () {
                            psyProv.reactToPost(i);
                          },
                        ),
                        Text("${post.reactionsCount}"),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.comment, color: Colors.grey),
                          onPressed: () {
                            psyProv.commentOnPost(i);
                          },
                        ),
                        Text("${post.commentsCount}"),
                      ],
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
