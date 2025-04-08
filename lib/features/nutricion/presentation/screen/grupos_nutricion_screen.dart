// lib/features/nutricion/presentation/screen/grupos_nutricion_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:paciente_app/features/nutricion/presentation/provider/nutricion_provider.dart';

class GruposNutricionScreen extends StatelessWidget {
  const GruposNutricionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nutriProv = context.watch<NutricionProvider>();
    final posts = nutriProv.posts;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Grupos de Nutrición"),
        backgroundColor: Colors.blueGrey,
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
                Text(p.content),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.thumb_up, color: Colors.blue),
                          onPressed: () {
                            nutriProv.reactToPost(i);
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
                            nutriProv.commentOnPost(i);
                          },
                        ),
                        Text("${p.comments}")
                      ],
                    )
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
