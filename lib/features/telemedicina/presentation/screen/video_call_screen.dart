import 'dart:async';
import 'package:flutter/material.dart';

class VideoCallScreen extends StatefulWidget {
  final String doctorName;
  final String doctorSpecialty;
  final String doctorImage;

  const VideoCallScreen({
    Key? key,
    required this.doctorName,
    required this.doctorSpecialty,
    required this.doctorImage,
  }) : super(key: key);

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  bool _isMicOn = true;
  bool _isCameraOn = true;
  int _callSeconds = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Iniciar el temporizador
    _startTimer();
  }

  @override
  void dispose() {
    // Cancelar el timer al cerrar la pantalla
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _callSeconds++;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final callMinutes = (_callSeconds ~/ 60).toString().padLeft(2, '0');
    final callSecs = (_callSeconds % 60).toString().padLeft(2, '0');
    final callTimeStr = "$callMinutes:$callSecs";

    return Scaffold(
      body: Stack(
        children: [
          // 1) Imagen a pantalla completa
          Positioned.fill(
            child: Image.asset(
              widget.doctorImage,
              fit: BoxFit.cover,
            ),
          ),

          // 2) Degradado en la parte inferior
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 200,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black54],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // 3) Info del doctor (nombre, especialidad, tiempo)
          Positioned(
            left: 16,
            right: 16,
            bottom: 80,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(widget.doctorImage),
                  radius: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.doctorName,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      Text(
                        widget.doctorSpecialty,
                        style: const TextStyle(fontSize: 14, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.fiber_manual_record, color: Colors.red, size: 14),
                      const SizedBox(width: 4),
                      Text(callTimeStr, style: const TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 4) Controles (mic, cam, colgar, etc.)
          Positioned(
            left: 0,
            right: 0,
            bottom: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCircleButton(
                  icon: _isMicOn ? Icons.mic : Icons.mic_off,
                  iconColor: Colors.white,
                  bgColor: Colors.black54,
                  onTap: () {
                    setState(() => _isMicOn = !_isMicOn);
                  },
                ),
                _buildCircleButton(
                  icon: _isCameraOn ? Icons.videocam : Icons.videocam_off,
                  iconColor: Colors.white,
                  bgColor: Colors.black54,
                  onTap: () {
                    setState(() => _isCameraOn = !_isCameraOn);
                  },
                ),
                _buildCircleButton(
                  icon: Icons.call_end,
                  iconColor: Colors.white,
                  bgColor: Colors.red,
                  onTap: () {
                    // Terminar llamada
                    Navigator.pop(context);
                  },
                ),
                _buildCircleButton(
                  icon: Icons.volume_up,
                  iconColor: Colors.white,
                  bgColor: Colors.black54,
                  onTap: () {
                    // ...
                  },
                ),
                _buildCircleButton(
                  icon: Icons.more_vert,
                  iconColor: Colors.white,
                  bgColor: Colors.black54,
                  onTap: () {
                    // ...
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor),
      ),
    );
  }
}
