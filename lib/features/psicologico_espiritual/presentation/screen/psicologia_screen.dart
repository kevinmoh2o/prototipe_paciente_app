import 'package:flutter/material.dart';
import 'package:paciente_app/features/psicologico_espiritual/data/model/psicologia_option_model.dart';
import 'package:paciente_app/features/psicologico_espiritual/data/service/psicologia_service.dart';
import 'package:paciente_app/features/psicologico_espiritual/presentation/widgets/psy_option_card.dart';

class PsicologiaScreen extends StatefulWidget {
  const PsicologiaScreen({Key? key}) : super(key: key);

  @override
  State<PsicologiaScreen> createState() => _PsicologiaScreenState();
}

class _PsicologiaScreenState extends State<PsicologiaScreen> with SingleTickerProviderStateMixin {
  late final List<PsicologiaOptionModel> _options;
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _options = PsicologiaService.options;

    // Animación para FadeIn del listado
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward(); // inicias la animación
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = theme.scaffoldBackgroundColor; // color de fondo

    return Scaffold(
      appBar: AppBar(
        title: const Text("Apoyo Psicológico y Espiritual"),
        backgroundColor: const Color(0xFF5B6BF5),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        titleTextStyle: theme.textTheme.headlineSmall!.copyWith(color: const Color.fromARGB(221, 255, 255, 255)),
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true, // para que el AppBar flote sobre el CustomPaint
      body: Stack(
        children: [
          // Fondo con un CustomPaint curvo degradé
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, 300), // altura del header
            painter: _PsyHeaderPainter(),
          ),

          // Contenido principal
          SafeArea(
            child: FadeTransition(
              opacity: _animation,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    /* const SizedBox(height: 100), // espacio debajo del AppBar
                    // Texto principal o banner
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        "Encuentra apoyo psicológico y espiritual",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ), */
                    const SizedBox(height: 20),

                    // Lista de opciones
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _options.length,
                      itemBuilder: (context, index) {
                        final opt = _options[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: PsyOptionCard(option: opt),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Pintor personalizado para el header con un degradé y una curva suave
class _PsyHeaderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    final Gradient gradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF94C0FF), Color(0xFFFFFFFF)],
      stops: [0.0, 1.0],
    );

    final paint = Paint()..shader = gradient.createShader(rect);

    final path = Path();
    path.lineTo(0, size.height - 50);

    final controlPoint = Offset(size.width / 2, size.height);
    final endPoint = Offset(size.width, size.height - 50);

    path.quadraticBezierTo(
      controlPoint.dx,
      controlPoint.dy,
      endPoint.dx,
      endPoint.dy,
    );
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldReclip(_PsyHeaderPainter oldDelegate) => false;

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // No need to repaint since the design is static and does not change dynamically
    return false;
  }
}
