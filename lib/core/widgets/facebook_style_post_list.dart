import 'package:flutter/material.dart';
import 'package:paciente_app/core/data/models/grupo_post_model.dart';
import 'package:paciente_app/core/data/models/comment_model.dart';

class FacebookStylePostList extends StatefulWidget {
  final List<GrupoPost> posts;

  // Se recibe el tipo de reacción también
  final Function(int postIndex, String reactionType) onReactToPost;
  final Function(int postIndex, String commentText) onAddCommentToPost;
  final Function(int postIndex, int commentIndex) onReactToComment;

  // NUEVO: callback para crear un Post
  final Function(String newPostContent)? onCreatePost;

  const FacebookStylePostList({
    Key? key,
    required this.posts,
    required this.onReactToPost,
    required this.onAddCommentToPost,
    required this.onReactToComment,
    this.onCreatePost,
  }) : super(key: key);

  @override
  State<FacebookStylePostList> createState() => _FacebookStylePostListState();
}

class _FacebookStylePostListState extends State<FacebookStylePostList> {
  /// Maneja si los comentarios de un post están expandidos o no (uno por cada post).
  late List<bool> _expandedComments;

  // NUEVO: para capturar texto del nuevo post
  final TextEditingController _newPostController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Inicialmente, todos los posts con comentarios "comprimidos"
    _expandedComments = List<bool>.filled(widget.posts.length, false, growable: true);
  }

  @override
  void dispose() {
    _newPostController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant FacebookStylePostList oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Si el número de posts cambió, ajustamos la lista
    if (widget.posts.length != _expandedComments.length) {
      _expandedComments = List<bool>.filled(widget.posts.length, false, growable: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ────────────────── Sección para crear un nuevo post (opcional)
        if (widget.onCreatePost != null) _buildNewPostSection(),

        // ────────────────── Lista de posts
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: widget.posts.length,
            itemBuilder: (ctx, postIndex) {
              final post = widget.posts[postIndex];
              final comments = post.comments;
              final isExpanded = _expandedComments[postIndex];

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Autor
                    Text(
                      post.author,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(height: 4),
                    // Contenido
                    Text(post.content),
                    const SizedBox(height: 8),

                    // ────────────────── Resumen de reacciones (solo íconos, sin texto)
                    if (post.totalReactions > 0)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            // Muestra los íconos en orden
                            for (String reactionType in post.getUsedReactionsInOrder())
                              Padding(
                                padding: const EdgeInsets.only(right: 4),
                                child: _buildReactionIcon(reactionType, 18), // tamaño 18
                              ),
                            // Si deseas mostrar la cantidad total:
                            Text("${post.totalReactions}"),
                          ],
                        ),
                      ),

                    // Cantidad de comentarios
                    Text(
                      "${comments.length} comentarios",
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const Divider(height: 20),

                    // ────────────────── Botón único (estilo Facebook) para reacciones
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Menú vertical con las 5 reacciones
                        PopupMenuButton<String>(
                          offset: const Offset(0, -200), // Para que aparezca "arriba" del botón
                          tooltip: "Reaccionar",
                          child: Row(
                            children: const [
                              Icon(Icons.add_reaction_outlined, color: Colors.blue),
                              SizedBox(width: 6),
                              Text("Reaccionar", style: TextStyle(color: Colors.blue)),
                            ],
                          ),
                          onSelected: (String selectedReaction) {
                            widget.onReactToPost(postIndex, selectedReaction);
                          },
                          itemBuilder: (context) => [
                            _buildPopupMenuItem("like", "👍 Like"),
                            _buildPopupMenuItem("love", "❤️ Love"),
                            _buildPopupMenuItem("haha", "😂 Haha"),
                            _buildPopupMenuItem("wow", "😮 Wow"),
                            _buildPopupMenuItem("sad", "😢 Sad"),
                          ],
                        ),
                        const SizedBox(width: 16),
                        // Botón Comentar
                        InkWell(
                          onTap: () => _showCommentDialog(context, postIndex),
                          child: Row(
                            children: const [
                              Icon(Icons.comment_outlined, color: Colors.blue),
                              SizedBox(width: 6),
                              Text("Comentar", style: TextStyle(color: Colors.blue)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // ────────────────── Listado de comentarios
                    if (comments.isNotEmpty)
                      Column(
                        children: [
                          for (int i = 0; i < comments.length; i++)
                            // Muestra solo 2 si está comprimido
                            if (isExpanded || i < 2) _buildCommentItem(context, postIndex, i, comments[i]),
                          // Botón para ver más / menos
                          if (comments.length > 2)
                            GestureDetector(
                              onTap: () => _toggleExpandComments(postIndex),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Text(
                                  isExpanded ? "Ver menos comentarios" : "Ver más comentarios (${comments.length - 2})",
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // SECCIÓN NUEVA: para crear un Post al estilo "¿Qué estás pensando?"
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildNewPostSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 22,
            child: Icon(Icons.person, size: 20),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _newPostController,
              decoration: const InputDecoration(
                hintText: "¿Qué estás pensando?",
                border: InputBorder.none,
              ),
              maxLines: 3,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              final text = _newPostController.text.trim();
              if (text.isNotEmpty) {
                widget.onCreatePost?.call(text);
                _newPostController.clear();
              }
            },
          ),
        ],
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // COMENTARIOS
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildCommentItem(BuildContext context, int postIndex, int commentIndex, Comment comment) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(radius: 12, child: Icon(Icons.person, size: 14)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comment.author,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                Text(
                  comment.content,
                  style: const TextStyle(fontSize: 13),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    InkWell(
                      onTap: () => widget.onReactToComment(postIndex, commentIndex),
                      child: Text(
                        "Me gusta (${comment.reactions})",
                        style: const TextStyle(fontSize: 12, color: Colors.blue),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      _formatDate(comment.createdAt),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // REACCIONES
  // ───────────────────────────────────────────────────────────────────────────
  PopupMenuItem<String> _buildPopupMenuItem(String value, String text) {
    return PopupMenuItem<String>(
      value: value,
      child: Text(text, style: const TextStyle(fontSize: 14)),
    );
  }

  Widget _buildReactionIcon(String reactionType, double size) {
    switch (reactionType) {
      case "like":
        return Text("👍", style: TextStyle(fontSize: size));
      case "love":
        return Text("❤️", style: TextStyle(fontSize: size));
      case "haha":
        return Text("😂", style: TextStyle(fontSize: size));
      case "wow":
        return Text("😮", style: TextStyle(fontSize: size));
      case "sad":
        return Text("😢", style: TextStyle(fontSize: size));
      default:
        return const SizedBox.shrink();
    }
  }

  // ───────────────────────────────────────────────────────────────────────────
  // ÚTILES
  // ───────────────────────────────────────────────────────────────────────────
  void _showCommentDialog(BuildContext context, int postIndex) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text("Escribe un comentario"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: "Comparte tus pensamientos...",
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
            ElevatedButton(
              child: const Text("Comentar"),
              onPressed: () {
                final text = controller.text.trim();
                if (text.isNotEmpty) {
                  widget.onAddCommentToPost(postIndex, text);
                }
                Navigator.of(ctx).pop();
              },
            )
          ],
        );
      },
    );
  }

  void _toggleExpandComments(int postIndex) {
    setState(() {
      _expandedComments[postIndex] = !_expandedComments[postIndex];
    });
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}
