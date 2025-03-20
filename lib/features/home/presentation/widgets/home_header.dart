import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  final String userName;
  final String userAvatar;

  const HomeHeader({
    Key? key,
    required this.userName,
    required this.userAvatar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: Stack(
        children: [
          // Fondo con curva
          ClipPath(
            clipper: _HeaderClipper(),
            child: Container(
              color: Color(0xFF5B6BF5), // Un lila o morado
              height: 180,
            ),
          ),
          // Contenido: avatar + bienvenida + logo
          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: Row(
              children: [
                // Avatar circular
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage(userAvatar),
                ),
                const SizedBox(width: 16),
                // Bienvenida
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Bienvenido(a)",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        userName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                // Logo Onco360 (texto + ícono)
                Column(
                  children: [
                    Image.asset(
                      "assets/images/logo_blanco.png",
                      scale: 5,
                    ),
                    /* Text(
                      "Onco 360",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Icon(
                      Icons.health_and_safety,
                      color: Colors.white,
                      size: 28,
                    ), */
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // Crea una curva suave en la parte inferior
    final path = Path();
    path.lineTo(0, size.height - 40);

    final controlPoint = Offset(size.width / 2, size.height);
    final endPoint = Offset(size.width, size.height - 40);

    path.quadraticBezierTo(
      controlPoint.dx,
      controlPoint.dy,
      endPoint.dx,
      endPoint.dy,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(_HeaderClipper oldClipper) => false;
}
