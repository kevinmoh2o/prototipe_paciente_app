import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String initials;
  final double radius;
  final String? photoUrl; // Opcional, si tuvieras foto real

  const ProfileAvatar({
    Key? key,
    required this.initials,
    this.radius = 40,
    this.photoUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (photoUrl != null && photoUrl!.isNotEmpty) {
      // Muestra la imagen
      return CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(photoUrl!),
      );
    } else {
      // Muestra iniciales
      return CircleAvatar(
        radius: radius,
        backgroundColor: Colors.blueGrey,
        child: Text(
          initials,
          style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
      );
    }
  }
}
