import 'package:flutter/material.dart';

class UpgradeButton extends StatelessWidget {
  final Color color; // El color que se le pasa
  final VoidCallback onPressed;

  const UpgradeButton({super.key, required this.onPressed, required this.color});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(
        Icons.diamond, // Usamos el ícono de diamante
        color: Colors.white,
      ),
      label: const Text(
        'Upgrade plan',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color, // Aquí aplicamos el color que se pasa al botón
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
