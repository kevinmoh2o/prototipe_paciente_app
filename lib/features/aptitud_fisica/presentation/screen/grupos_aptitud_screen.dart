// lib/features/aptitud_fisica/presentation/screen/grupos_aptitud_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:paciente_app/features/aptitud_fisica/presentation/provider/aptitud_provider.dart';

class GruposAptitudScreen extends StatelessWidget {
  const GruposAptitudScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final aptProv = context.watch<AptitudProvider>();
    final posts = aptProv.posts;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Grupos de Aptitud"),
        backgroundColor: Colors.orange,
      ),
      body: ListView.builder(
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
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.thumb_up, color: Colors.blue),
                          onPressed: () {
                            aptProv.reactToPost(i);
                          },
                        ),
                        Text("${p.reactions}")
                      ],
                    ),
                    const SizedBox(width: 16),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.comment, color: Colors.grey),
                          onPressed: () {
                            aptProv.commentOnPost(i);
                          },
                        ),
                        Text("${p.comments}")
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
