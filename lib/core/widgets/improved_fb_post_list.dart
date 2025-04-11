/* import 'package:flutter/material.dart';
import 'package:paciente_app/core/data/models/grupo_post_model.dart';
import 'package:paciente_app/core/data/models/comment_model.dart';

class ImprovedFbPostList extends StatelessWidget {
  final List<GrupoPost> posts;
  final Function(int postIndex) onReactToPost;
  final Function(int postIndex, String commentText) onAddCommentToPost;
  final Function(int postIndex, int commentIndex) onReactToComment;

  const ImprovedFbPostList({
    Key? key,
    required this.posts,
    required this.onReactToPost,
    required this.onAddCommentToPost,
    required this.onReactToComment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemCount: posts.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final post = posts[index];
        return _PostCard(
          post: post,
          postIndex: index,
          onReactToPost: onReactToPost,
          onAddCommentToPost: onAddCommentToPost,
          onReactToComment: onReactToComment,
        );
      },
    );
  }
}

class _PostCard extends StatefulWidget {
  final GrupoPost post;
  final int postIndex;
  final Function(int postIndex) onReactToPost;
  final Function(int postIndex, String commentText) onAddCommentToPost;
  final Function(int postIndex, int commentIndex) onReactToComment;

  const _PostCard({
    Key? key,
    required this.post,
    required this.postIndex,
    required this.onReactToPost,
    required this.onAddCommentToPost,
    required this.onReactToComment,
  }) : super(key: key);

  @override
  State<_PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<_PostCard> with SingleTickerProviderStateMixin {
  final _commentController = TextEditingController();
  final FocusNode _focusCommentField = FocusNode();

  // Variable para controlar el estado de colapso/expansión de comentarios
  bool _areCommentsExpanded = false;

  @override
  void dispose() {
    _commentController.dispose();
    _focusCommentField.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 5,
            offset: const Offset(0, 3),
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
          Text(
            post.content,
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 8),
          // Reacciones y contador de comentarios
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Contador de "likes"
              Row(
                children: [
                  const Icon(Icons.thumb_up, color: Colors.blue, size: 18),
                  const SizedBox(width: 4),
                  Text("${post.reactions}"),
                ],
              ),
              // Contador de comentarios
              Row(
                children: [
                  const Icon(Icons.comment, color: Colors.grey, size: 18),
                  const SizedBox(width: 4),
                  Text("${post.comments.length}"),
                ],
              ),
            ],
          ),
          const Divider(height: 20),
          // Botones "Me gusta" y "Comentar"
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton.icon(
                icon: const Icon(Icons.thumb_up_alt_outlined),
                label: const Text("Me gusta"),
                onPressed: () {
                  widget.onReactToPost(widget.postIndex);
                },
              ),
              TextButton.icon(
                icon: const Icon(Icons.comment_outlined),
                label: const Text("Comentar"),
                onPressed: () {
                  FocusScope.of(context).requestFocus(_focusCommentField);
                },
              ),
            ],
          ),
          // Botón para expandir o contraer comentarios si existen
          if (post.comments.isNotEmpty) ...[
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                setState(() {
                  _areCommentsExpanded = !_areCommentsExpanded;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    _areCommentsExpanded ? "Ocultar comentarios" : "Mostrar comentarios",
                    style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    _areCommentsExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: Colors.blue,
                  ),
                ],
              ),
            ),
            // Mostrar comentarios solo si están expandidos
            if (_areCommentsExpanded)
              ListView.builder(
                itemCount: post.comments.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, cIndex) {
                  final comment = post.comments[cIndex];
                  return _CommentItem(
                    comment: comment,
                    onReact: () => widget.onReactToComment(widget.postIndex, cIndex),
                  );
                },
              ),
          ],
          // Campo de texto para escribir un comentario nuevo
          const SizedBox(height: 8),
          Row(
            children: [
              const CircleAvatar(
                radius: 14,
                child: Icon(Icons.person, size: 14),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _commentController,
                  focusNode: _focusCommentField,
                  decoration: InputDecoration(
                    hintText: "Escribe un comentario...",
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  textInputAction: TextInputAction.send,
                  onSubmitted: (value) => _submitComment(),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send, color: Colors.blue),
                onPressed: _submitComment,
              )
            ],
          ),
        ],
      ),
    );
  }

  void _submitComment() {
    final text = _commentController.text.trim();
    if (text.isNotEmpty) {
      widget.onAddCommentToPost(widget.postIndex, text);
      _commentController.clear();
      FocusScope.of(context).unfocus();
    }
  }
}

// Un pequeño widget para cada comentario
class _CommentItem extends StatelessWidget {
  final Comment comment;
  final VoidCallback onReact;

  const _CommentItem({
    Key? key,
    required this.comment,
    required this.onReact,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                InkWell(
                  onTap: onReact,
                  child: Row(
                    children: [
                      const Icon(Icons.thumb_up_off_alt, color: Colors.blue, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        "${comment.reactions}",
                        style: const TextStyle(fontSize: 12, color: Colors.blue),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
 */
