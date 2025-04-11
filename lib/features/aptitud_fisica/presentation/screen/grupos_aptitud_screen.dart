// lib/features/aptitud_fisica/presentation/screen/grupos_aptitud_screen.dart

import 'package:flutter/material.dart';
import 'package:paciente_app/core/widgets/facebook_style_post_list.dart';
import 'package:paciente_app/core/widgets/grupo_post_list.dart';
import 'package:paciente_app/core/widgets/improved_fb_post_list.dart';
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
      /* body: GrupoPostList(posts: posts, onReact: (index) => {}, onComment: (index) => {}), */
      body: FacebookStylePostList(
        posts: posts,
        onReactToPost: (postIndex, reactionType) => aptProv.reactToPost(postIndex, reactionType),
        onAddCommentToPost: (postIndex, text) => aptProv.addCommentToPost(postIndex, text),
        onReactToComment: (postIndex, commentIndex) => aptProv.reactToComment(postIndex, commentIndex),
        onCreatePost: (content) {
          aptProv.addPost(content);
        },
      ),
    );
  }
}
