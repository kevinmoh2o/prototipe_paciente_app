import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String doctorName;
  final String doctorImage;
  final String lastSeen; // "hace 5 minutos"

  const ChatScreen({
    Key? key,
    required this.doctorName,
    required this.doctorImage,
    required this.lastSeen,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _msgCtrl = TextEditingController();

  // Lista de mensajes de ejemplo
  final List<_Message> _messages = [
    // Mensaje del doctor (lado izquierdo => isMine=false)
    _Message(text: "Buenos días, ¿cómo se encuentra hoy?", isMine: false, time: "9:13 a.m."),
    // Mensaje tuyo (lado derecho => isMine=true)
    _Message(text: "Buenos días, doctor. Estoy un poco preocupado por mi dosis de medicación.", isMine: true, time: "9:15 a.m."),
  ];

  @override
  void dispose() {
    _msgCtrl.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _msgCtrl.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        // Tu mensaje (lado derecho => isMine = true)
        _messages.add(_Message(text: text, isMine: true, time: "9:16 a.m."));
      });
      _msgCtrl.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar con foto y estado del doctor
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        automaticallyImplyLeading: true,
        backgroundColor: const Color(0xFF5B6BF5),
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(widget.doctorImage),
              radius: 20,
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.doctorName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                Text("Activo hace ${widget.lastSeen}", style: const TextStyle(fontSize: 12, color: Colors.white70))
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Lista de mensajes
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (ctx, i) {
                final msg = _messages[i];
                return _MessageBubble(msg: msg);
              },
            ),
          ),

          // Barra inferior con campo de texto + botón de enviar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgCtrl,
                    decoration: const InputDecoration(
                      hintText: "Escribe tu mensaje",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _sendMessage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5B6BF5),
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(14),
                    elevation: 2,
                    minimumSize: const Size(48, 48),
                  ),
                  child: const Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// Modelo sencillo para cada mensaje
class _Message {
  final String text;
  final bool isMine; // true => tu mensaje (derecha), false => doctor (izquierda)
  final String time;

  _Message({
    required this.text,
    required this.isMine,
    required this.time,
  });
}

// Widget para burbuja de chat
class _MessageBubble extends StatelessWidget {
  final _Message msg;
  const _MessageBubble({Key? key, required this.msg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Alineación horizontal
    final alignment = msg.isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final bubbleColor = msg.isMine ? Colors.green.shade100 : Colors.grey.shade200;
    final textColor = msg.isMine ? Colors.black : Colors.black87;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          // Burbuja
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: bubbleColor,
              borderRadius: BorderRadius.circular(8),
            ),
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
            child: Text(
              msg.text,
              style: TextStyle(color: textColor, fontSize: 14),
            ),
          ),
          const SizedBox(height: 2),
          // Hora
          Text(msg.time, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
      alignment: msg.isMine ? Alignment.centerRight : Alignment.centerLeft,
    );
  }
}
