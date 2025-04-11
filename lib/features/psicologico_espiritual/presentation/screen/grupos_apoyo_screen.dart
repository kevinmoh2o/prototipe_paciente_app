/// lib/features/psicologico_espiritual/presentation/screen/grupos_apoyo_screen.dart

import 'package:flutter/material.dart';
import 'package:paciente_app/core/widgets/improved_fb_post_list.dart';
import 'package:provider/provider.dart';
import 'package:paciente_app/features/psicologico_espiritual/presentation/provider/psicologia_provider.dart';
import 'package:paciente_app/core/widgets/facebook_style_post_list.dart';

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
      body: FacebookStylePostList(
        posts: posts,
        onReactToPost: (postIndex, reactionType) => psyProv.reactToPost(postIndex, reactionType),
        onAddCommentToPost: (postIndex, text) => psyProv.addCommentToPost(postIndex, text),
        onReactToComment: (postIndex, commentIndex) => psyProv.reactToComment(postIndex, commentIndex),
        onCreatePost: (content) {
          psyProv.addPost(content);
        },
      ),
    );
  }
}
