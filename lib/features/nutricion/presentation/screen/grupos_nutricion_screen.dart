/// lib/features/nutricion/presentation/screen/grupos_nutricion_screen.dart

import 'package:flutter/material.dart';
import 'package:paciente_app/core/widgets/improved_fb_post_list.dart';
import 'package:provider/provider.dart';
import 'package:paciente_app/features/nutricion/presentation/provider/nutricion_provider.dart';
import 'package:paciente_app/core/widgets/facebook_style_post_list.dart';

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
      body: FacebookStylePostList(
        posts: posts,
        onReactToPost: (postIndex, reactionType) => nutriProv.reactToPost(postIndex, reactionType),
        onAddCommentToPost: (postIndex, text) => nutriProv.addCommentToPost(postIndex, text),
        onReactToComment: (postIndex, commentIndex) => nutriProv.reactToComment(postIndex, commentIndex),
        onCreatePost: (content) {
          nutriProv.addPost(content);
        },
      ),
    );
  }
}
