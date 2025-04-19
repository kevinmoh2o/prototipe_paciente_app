import 'package:flutter/material.dart';
import 'package:paciente_app/core/constants/app_constants.dart';
import 'package:paciente_app/core/data/models/plan_data_model.dart';
import 'package:paciente_app/features/create_account/presentation/provider/patient_provider.dart';
import 'package:provider/provider.dart';

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
    final patientProvider = Provider.of<PatientProvider>(context, listen: false);
    final activePlan = patientProvider.patient.activePlan;

    final PlanData planObj = AppConstants.plans.firstWhere(
      (plan) => plan.title == activePlan,
      orElse: () => throw StateError('No se encontró el plan: $activePlan'),
    );

    return SizedBox(
      height: 180,
      child: Stack(
        children: [
          // Fondo curvo
          ClipPath(
            clipper: _HeaderClipper(),
            child: Container(
              color: const Color(0xFF5B6BF5),
              height: 180,
            ),
          ),

          // Cinta superior del plan (badge)
          if (activePlan != null)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: planObj.color,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(planObj.icon, color: Colors.white, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      activePlan,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Contenido principal
          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar circular
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage(userAvatar),
                ),
                const SizedBox(width: 16),

                // Texto de bienvenida
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Bienvenido(a)",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 2),
                    ],
                  ),
                ),

                // Logo Onco360 (si lo deseas mostrar)
                Image.asset(
                  "assets/images/logo_blanco.png",
                  scale: 5,
                ),
              ],
            ),
          ),

          // Nombre debajo del saludo
          Positioned(
            top: 65,
            left: 16 + 60 + 16, // avatar(60) + gap(16)
            child: Text(
              userName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Clipper para la curva
class _HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    // Comienza en la esquina superior izquierda
    path.lineTo(0, size.height - 40);

    // Punto de control y final para la curva
    final controlPoint = Offset(size.width / 2, size.height);
    final endPoint = Offset(size.width, size.height - 40);

    // Curva suave
    path.quadraticBezierTo(
      controlPoint.dx,
      controlPoint.dy,
      endPoint.dx,
      endPoint.dy,
    );
    // Cierra hasta la esquina superior derecha
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(_HeaderClipper oldClipper) => false;
}
