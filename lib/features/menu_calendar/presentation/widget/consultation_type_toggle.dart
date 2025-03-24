import 'package:flutter/material.dart';
import 'package:paciente_app/features/menu_calendar/presentation/provider/calendar_provider.dart';

class ConsultationTypeToggle extends StatelessWidget {
  final AppointmentCategory? currentValue;
  final ValueChanged<AppointmentCategory> onChanged;

  const ConsultationTypeToggle({
    Key? key,
    required this.currentValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPsico = (currentValue == AppointmentCategory.psicologico);
    final isNutri = (currentValue == AppointmentCategory.nutricion);
    final isTele = (currentValue == AppointmentCategory.telemedicina);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _TypeCard(
          label: "Apoyo\nPsicológico",
          icon: Icons.self_improvement,
          isSelected: isPsico,
          onTap: () => onChanged(AppointmentCategory.psicologico),
        ),
        _TypeCard(
          label: "Nutrición",
          icon: Icons.restaurant_menu,
          isSelected: isNutri,
          onTap: () => onChanged(AppointmentCategory.nutricion),
        ),
        _TypeCard(
          label: "Telemedicina",
          icon: Icons.video_camera_front,
          isSelected: isTele,
          onTap: () => onChanged(AppointmentCategory.telemedicina),
        ),
      ],
    );
  }
}

class _TypeCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _TypeCard({Key? key, required this.label, required this.icon, required this.isSelected, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 100,
        height: 80,
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF5B6BF5) : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.black54,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
